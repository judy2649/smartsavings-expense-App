import 'package:flutter/material.dart';
import '../../../core/repositories/savings_goals_repository.dart';
import '../../../core/models/savings_goal_model.dart';
import '../../../core/services/service_locator.dart';

class SavingsGoalsProvider extends ChangeNotifier {
  final SavingsGoalsRepository _savingsGoalsRepository = getIt<SavingsGoalsRepository>();
  
  List<SavingsGoal> _savingsGoals = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _totalSavingsTargets = 0;

  List<SavingsGoal> get savingsGoals => _savingsGoals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get totalSavingsTargets => _totalSavingsTargets;
  double get totalSavingsCompleted => _savingsGoals.fold(0, (sum, goal) => sum + goal.currentAmount);
  double get savingsProgress => totalSavingsTargets > 0 ? (totalSavingsCompleted / totalSavingsTargets * 100) : 0;

  Future<void> loadSavingsGoals(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _savingsGoals = await _savingsGoalsRepository.getSavingsGoals(userId);
      _totalSavingsTargets = await _savingsGoalsRepository.getTotalSavingsTargets(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<SavingsGoal>> watchSavingsGoals(String userId) {
    return _savingsGoalsRepository.getSavingsGoalsStream(userId);
  }

  Future<void> addSavingsGoal(String userId, SavingsGoal goal) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _savingsGoalsRepository.addSavingsGoal(userId, goal);
      _savingsGoals.add(goal);
      _totalSavingsTargets += goal.targetAmount;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSavingsGoal(String userId, SavingsGoal goal) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _savingsGoalsRepository.updateSavingsGoal(userId, goal);
      
      final index = _savingsGoals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _totalSavingsTargets -= _savingsGoals[index].targetAmount;
        _totalSavingsTargets += goal.targetAmount;
        _savingsGoals[index] = goal;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSavingsGoal(String userId, String goalId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final goal = _savingsGoals.firstWhere((g) => g.id == goalId);
      await _savingsGoalsRepository.deleteSavingsGoal(userId, goalId);
      
      _savingsGoals.removeWhere((g) => g.id == goalId);
      _totalSavingsTargets -= goal.targetAmount;
      
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
