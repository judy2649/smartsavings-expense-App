import 'package:flutter_test/flutter_test.dart';
import 'package:smart_savings/core/services/budget_engine_service.dart';
import 'package:smart_savings/core/models/budget_category.dart';
import 'package:smart_savings/core/models/savings_goal.dart';

void main() {
  group('BudgetEngineService', () {
    test('suggestBudget proportional allocates disposable equally when no pct provided', () async {
      final service = BudgetEngineService();
      final categories = [
        BudgetCategory(id: 'c1', name: 'A', allocationPct: 0, allocationAmount: 0, spentMonthToDate: 0),
        BudgetCategory(id: 'c2', name: 'B', allocationPct: 0, allocationAmount: 0, spentMonthToDate: 0),
      ];
      final goals = <SavingsGoal>[];

      final res = await service.suggestBudget(income: 10000, fixedMonthly: 2000, categories: categories, goals: goals, preset: 'proportional');
      expect(res.containsKey('allocations'), true);
      final allocations = Map<String, double>.from(res['allocations'] as Map);
      expect(allocations.length, 2);
      expect(res['disposable'], 8000);
      // each category should get half of disposable
      expect(allocations['c1'], closeTo(4000.0, 0.01));
      expect(allocations['c2'], closeTo(4000.0, 0.01));
    });

    test('detectOverspend returns soft and hard alerts', () {
      final service = BudgetEngineService();
      final categories = [
        BudgetCategory(id: 'c1', name: 'Groceries', allocationPct: 0.2, allocationAmount: 1000, spentMonthToDate: 900),
        BudgetCategory(id: 'c2', name: 'Dining', allocationPct: 0.1, allocationAmount: 500, spentMonthToDate: 600),
      ];
      final alerts = service.detectOverspend(categories);
      expect(alerts.length, 2);
      expect(alerts.any((a) => a['type'] == 'soft' && a['categoryId'] == 'c1'), true);
      expect(alerts.any((a) => a['type'] == 'hard' && a['categoryId'] == 'c2'), true);
    });
  });
}
