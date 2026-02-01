import 'package:flutter/material.dart';
import '../../../core/repositories/transactions_repository.dart';
import '../../../core/repositories/accounts_repository.dart';
import '../../../core/services/service_locator.dart';

class DashboardProvider extends ChangeNotifier {
  final TransactionsRepository _transactionsRepository = getIt<TransactionsRepository>();
  final AccountsRepository _accountsRepository = getIt<AccountsRepository>();
  
  double _totalBalance = 0;
  double _monthlyExpenses = 0;
  double _weeklyExpenses = 0;
  bool _isLoading = false;
  String? _errorMessage;

  double get totalBalance => _totalBalance;
  double get monthlyExpenses => _monthlyExpenses;
  double get weeklyExpenses => _weeklyExpenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboardData(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load total balance
      _totalBalance = await _accountsRepository.getTotalBalance(userId);

      // Load monthly expenses
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0);
      
      _monthlyExpenses = await _transactionsRepository.getTotalExpenses(
        userId,
        startDate: monthStart,
        endDate: monthEnd,
      );

      // Load weekly expenses
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      _weeklyExpenses = await _transactionsRepository.getTotalExpenses(
        userId,
        startDate: weekStart,
        endDate: weekEnd,
      );
      
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
