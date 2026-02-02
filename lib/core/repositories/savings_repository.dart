import '../models/savings_goal.dart';

class SavingsRepository {
  final Map<String, SavingsGoal> _store = {};

  List<SavingsGoal> getGoals() => _store.values.toList(growable: false);

  SavingsGoal createGoal(SavingsGoal goal) {
    _store[goal.id] = goal;
    return goal;
  }

  SavingsGoal? getGoalById(String id) => _store[id];

  void deleteGoal(String id) {
    _store.remove(id);
  }

  /// Contribute amount to a goal and return updated goal
  SavingsGoal contributeToGoal(String id, double amount) {
    final goal = _store[id];
    if (goal == null) throw StateError('Goal not found');
    final newAmount = (goal.currentAmount + amount).clamp(0.0, goal.targetAmount);
    final updated = goal.copyWith(currentAmount: newAmount, isActive: newAmount < goal.targetAmount);
    _store[id] = updated;
    return updated;
  }

  SavingsGoal updateGoal(String id, {String? name, double? targetAmount, DateTime? deadline}) {
    final goal = _store[id];
    if (goal == null) throw StateError('Goal not found');
    final updated = goal.copyWith(
      name: name,
      targetAmount: targetAmount,
      deadline: deadline,
    );
    _store[id] = updated;
    return updated;
  }
}
