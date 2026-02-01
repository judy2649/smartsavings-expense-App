import 'package:flutter_test/flutter_test.dart';
import 'package:smart_savings/core/services/service_locator.dart' as sl;
import 'package:smart_savings/core/services/aggregator_service.dart';
import 'package:smart_savings/core/repositories/transactions_repository.dart';
import 'package:smart_savings/features/transactions/providers/transactions_provider.dart';
import 'package:smart_savings/core/models/transaction.dart' as norm;
import 'package:smart_savings/core/models/transaction_model.dart' as app_tx;

class FakeAggregator extends AggregatorService {
  FakeAggregator();

  @override
  Future<List<norm.TransactionModel>> ingestAndNormalize(List<Map<String, dynamic>> payloads, {required String source}) async {
    final now = DateTime.now();
    final tx = norm.TransactionModel(
      id: 'tx-1',
      date: now,
      postedDate: null,
      amount: -100.0,
      currency: 'KES',
      merchant: 'Mpesa Store',
      rawDescription: 'PAYBILL XYZ',
      category: null,
      source: 'MPESA',
      accountId: '254700000000',
      status: 'SETTLED',
    );
    return [tx];
  }

  @override
  List<norm.TransactionModel> dedupe(List<norm.TransactionModel> incoming, List<norm.TransactionModel> existing) {
    // For this fake, assume no existing and return incoming unchanged
    return incoming;
  }
}

class FakeTransactionsRepository implements TransactionsRepository {
  final List<app_tx.Transaction> added = [];

  @override
  Future<bool> addTransaction(String userId, app_tx.Transaction transaction) async {
    added.add(transaction);
    return true;
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    // no-op
  }

  @override
  Future<List<app_tx.Transaction>> getTransactions(String userId, {DateTime? startDate, DateTime? endDate, String? category, String? type}) async {
    return [];
  }

  @override
  Stream<List<app_tx.Transaction>> getTransactionsStream(String userId, {DateTime? startDate, DateTime? endDate}) {
    return const Stream.empty();
  }

  @override
  Future<double> getTotalExpenses(String userId, {DateTime? startDate, DateTime? endDate}) async {
    return 0.0;
  }

  @override
  Future<void> updateTransaction(String userId, app_tx.Transaction transaction) async {
    // no-op
  }
}

void main() {
  setUp(() {
    sl.getIt.reset();
    // We'll inject fakes directly into the provider constructor below; still reset global locator to keep clean state.
  });

  test('ingestFromAggregator adds normalized, deduped transactions and updates provider state', () async {
    final fakeRepo = FakeTransactionsRepository();
    final fakeAgg = FakeAggregator();
    final provider = TransactionsProvider(transactionsRepository: fakeRepo, aggregatorService: fakeAgg);
    final userId = 'user-123';

    final payloads = [
      {'raw': 'sample mpesa payload'}
    ];

    final added = await provider.ingestFromAggregator(userId, payloads, source: 'MPESA');

    expect(added.length, 1);
    expect(provider.transactions.length, 1);
    expect(provider.transactions.first.amount, 100.0);
    // since the fake transaction amount was negative (-100) we treat it as expense
    expect(provider.totalExpenses, 100.0);

    // verify repository received the added transaction
    expect(fakeRepo.added.length, 1);
    expect(fakeRepo.added.first.id, added.first);
  });
}
