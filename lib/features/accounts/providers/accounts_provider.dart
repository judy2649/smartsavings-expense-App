import 'package:flutter/material.dart';

import '../../../core/repositories/accounts_repository.dart';
import '../../../core/models/account_model.dart';
import '../../../core/services/service_locator.dart';

class AccountsProvider extends ChangeNotifier {
  final AccountsRepository _accountsRepository = getIt<AccountsRepository>();

  List<Account> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _totalBalance = 0;

  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get totalBalance => _totalBalance;

  Future<void> loadAccounts(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _accounts = await _accountsRepository.getAccounts(userId);
      _totalBalance = await _accountsRepository.getTotalBalance(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Account>> watchAccounts(String userId) {
    return _accountsRepository.getAccountsStream(userId);
  }

  Future<void> addAccount(String userId, Account account) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _accountsRepository.addAccount(userId, account);
      _accounts.add(account);
      _totalBalance += account.balance;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAccount(String userId, Account account) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _accountsRepository.updateAccount(userId, account);

      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _totalBalance -= _accounts[index].balance;
        _totalBalance += account.balance;
        _accounts[index] = account;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount(String userId, String accountId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final account = _accounts.firstWhere((a) => a.id == accountId);
      await _accountsRepository.deleteAccount(userId, accountId);

      _accounts.removeWhere((a) => a.id == accountId);
      _totalBalance -= account.balance;

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
