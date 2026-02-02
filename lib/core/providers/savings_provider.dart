import 'package:flutter/foundation.dart';
import '../models/savings_goal.dart';
import '../repositories/savings_repository.dart';

class SavingsProvider extends ChangeNotifier {
  final SavingsRepository _repo;

  SavingsProvider({SavingsRepository? repository}) : _repo = repository ?? SavingsRepository();

  List<SavingsGoal> get goals => _repo.getGoals();

  SavingsGoal createGoal(SavingsGoal goal) {
    final g = _repo.createGoal(goal);
    notifyListeners();
    return g;
  }

  SavingsGoal contribute(String id, double amount) {
    final g = _repo.contributeToGoal(id, amount);
    notifyListeners();
    return g;
  }

  SavingsGoal? getById(String id) => _repo.getGoalById(id);

  void delete(String id) {
    _repo.deleteGoal(id);
    notifyListeners();
  }
}
