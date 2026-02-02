import 'package:flutter_test/flutter_test.dart';
import 'package:smart_savings/core/models/savings_goal.dart';
import 'package:smart_savings/core/repositories/savings_repository.dart';

void main() {
  group('SavingsGoal model', () {
    test('percentageCompleted computes correctly and clamps', () {
      final g = SavingsGoal(
        id: 'g1',
        userId: 'u1',
        name: 'Vacation',
        targetAmount: 1000.0,
        currentAmount: 250.0,
        deadline: DateTime.now().add(const Duration(days: 90)),
        createdAt: DateTime.now(),
      );
      expect(g.percentageCompleted, closeTo(25.0, 0.001));
    });
  });

  group('SavingsRepository', () {
    test('create, retrieve and contribute', () {
      final repo = SavingsRepository();
      final goal = SavingsGoal(
        id: 'g2',
        userId: 'u1',
        name: 'Emergency',
        targetAmount: 500.0,
        currentAmount: 0.0,
        deadline: DateTime.now().add(const Duration(days: 365)),
        createdAt: DateTime.now(),
      );
      repo.createGoal(goal);

      var fetched = repo.getGoalById('g2');
      expect(fetched, isNotNull);
      expect(fetched!.name, equals('Emergency'));

      repo.contributeToGoal('g2', 200.0);
      fetched = repo.getGoalById('g2');
      expect(fetched!.currentAmount, equals(200.0));

      repo.contributeToGoal('g2', 400.0);
      fetched = repo.getGoalById('g2');
      expect(fetched!.currentAmount, equals(500.0));
      expect(fetched.isCompleted, isTrue);
    });
  });
}
