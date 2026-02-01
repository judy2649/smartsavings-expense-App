import 'package:flutter/material.dart';
import '../../../core/repositories/transactions_repository.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/models/transaction.dart' as normalized;
import '../../../core/services/aggregator_service.dart';
import '../../../core/services/service_locator.dart';

class TransactionsProvider extends ChangeNotifier {
  final TransactionsRepository _transactionsRepository;
  final AggregatorService _aggregatorService;

  TransactionsProvider({TransactionsRepository? transactionsRepository, AggregatorService? aggregatorService})
      : _transactionsRepository = transactionsRepository ?? getIt<TransactionsRepository>(),
        _aggregatorService = aggregatorService ?? getIt<AggregatorService>();
  
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _totalExpenses = 0;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get totalExpenses => _totalExpenses;

  Future<void> loadTransactions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? type,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _transactions = await _transactionsRepository.getTransactions(
        userId,
        startDate: startDate,
        endDate: endDate,
        category: category,
        type: type,
      );
      
      _totalExpenses = await _transactionsRepository.getTotalExpenses(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Transaction>> watchTransactions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _transactionsRepository.getTransactionsStream(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> addTransaction(String userId, Transaction transaction) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final added = await _transactionsRepository.addTransaction(userId, transaction);
      if (added) {
        _transactions.insert(0, transaction);

        if (transaction.type == 'expense') {
          _totalExpenses += transaction.amount;
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ingest raw payloads from an external aggregator (e.g., MPESA), normalize,
  /// dedupe against persisted transactions and persist any new transactions.
  /// Returns list of added transaction ids.
  Future<List<String>> ingestFromAggregator(
    String userId,
    List<Map<String, dynamic>> payloads, {
    required String source,
  }) async {
    final aggregator = _aggregatorService;
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final incoming = await aggregator.ingestAndNormalize(payloads, source: source);

      if (incoming.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // Narrow fetch window to incoming range (with small padding)
      DateTime minDate = incoming.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);
      DateTime maxDate = incoming.map((t) => t.date).reduce((a, b) => a.isAfter(b) ? a : b);

      final existing = await _transactionsRepository.getTransactions(
        userId,
        startDate: minDate.subtract(const Duration(days: 1)),
        endDate: maxDate.add(const Duration(days: 1)),
      );

      // Convert existing (app Transaction) -> normalized.TransactionModel for dedupe comparison
      final existingNorm = existing.map((e) {
        return normalized.TransactionModel(
          id: e.id,
          date: e.date,
          postedDate: null,
          amount: e.amount,
          currency: 'KES',
          merchant: null,
          rawDescription: e.description,
          category: e.category,
          source: 'UNKNOWN',
          accountId: e.accountId,
          status: 'SETTLED',
        );
      }).toList();

      final deduped = aggregator.dedupe(incoming, existingNorm);

      final addedIds = <String>[];
      for (final n in deduped) {
        final tx = _fromNormalizedToAppTransaction(userId, n);
        final created = await _transactionsRepository.addTransaction(userId, tx);
        if (created) {
          _transactions.insert(0, tx);
          if (tx.type == 'expense') {
            _totalExpenses += tx.amount;
          }
          addedIds.add(tx.id);
        }
      }

      _isLoading = false;
      notifyListeners();
      return addedIds;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Transaction _fromNormalizedToAppTransaction(String userId, normalized.TransactionModel n) {
    // Heuristic: positive amounts are income, negative are expense (if any)
    final type = (n.amount < 0) ? 'expense' : 'income';

    return Transaction(
      id: n.id,
      userId: userId,
      accountId: n.accountId,
      category: n.category ?? 'uncategorized',
      type: type,
      amount: n.amount.abs(),
      description: n.rawDescription.isNotEmpty ? n.rawDescription : (n.merchant ?? ''),
      date: n.date,
      createdAt: DateTime.now(),
      isRecurring: false,
      recurringPeriod: null,
      recurringEndDate: null,
      icon: '💳',
      color: 0xFF6B7280,
    );
  }

  Future<void> updateTransaction(String userId, Transaction transaction) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _transactionsRepository.updateTransaction(userId, transaction);
      
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String userId, String transactionId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final transaction = _transactions.firstWhere((t) => t.id == transactionId);
      await _transactionsRepository.deleteTransaction(userId, transactionId);
      
      _transactions.removeWhere((t) => t.id == transactionId);
      
      if (transaction.type == 'expense') {
        _totalExpenses -= transaction.amount;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
