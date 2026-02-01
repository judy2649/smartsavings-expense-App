import 'package:flutter/material.dart';
import '../../../core/repositories/budgets_repository.dart';
import '../../../core/models/budget_model.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/services/budget_engine_service.dart';
import '../../../core/models/budget_category.dart';
import '../../../core/models/savings_goal.dart';

class BudgetsProvider extends ChangeNotifier {
  final BudgetsRepository _budgetsRepository = getIt<BudgetsRepository>();
  final BudgetEngineService _budgetEngine = getIt<BudgetEngineService>();
  
  List<Budget> _budgets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Budget> get exceedingBudgets => _budgets.where((b) => b.isExceeded).toList();
  List<Budget> get nearingLimitBudgets => _budgets.where((b) => b.isNearingLimit && !b.isExceeded).toList();

  Future<void> loadBudgets(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _budgets = await _budgetsRepository.getBudgets(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Budget>> watchBudgets(String userId) {
    return _budgetsRepository.getBudgetsStream(userId);
  }

  Future<void> addBudget(String userId, Budget budget) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _budgetsRepository.addBudget(userId, budget);
      _budgets.add(budget);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBudget(String userId, Budget budget) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _budgetsRepository.updateBudget(userId, budget);
      
      final index = _budgets.indexWhere((b) => b.id == budget.id);
      if (index != -1) {
        _budgets[index] = budget;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String userId, String budgetId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _budgetsRepository.deleteBudget(userId, budgetId);
      _budgets.removeWhere((b) => b.id == budgetId);
      
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

  /// Suggest budget allocations using the BudgetEngineService.
  Future<Map<String, dynamic>> suggestBudget({
    required double income,
    required double fixedMonthly,
    required List<BudgetCategory> categories,
    required List<SavingsGoal> goals,
    String preset = 'proportional',
  }) async {
    return await _budgetEngine.suggestBudget(
      income: income,
      fixedMonthly: fixedMonthly,
      categories: categories,
      goals: goals,
      preset: preset,
    );
  }
}
