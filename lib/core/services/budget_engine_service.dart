// Budget Engine Service (detailed skeleton)
import 'dart:math';

import '../models/budget_category.dart';
import '../models/savings_goal.dart';

class BudgetEngineService {
  BudgetEngineService();

  /// Suggest budget allocations given income, fixed expenses and categories.
  /// Returns a map with:
  /// - allocations: Map<String, double> categoryId -> allocationAmount
  /// - suggestedSavings: double (total monthly suggested towards goals)
  /// - disposable: double
  /// - warnings: List<String>
  Future<Map<String, dynamic>> suggestBudget({
    required double income,
    required double fixedMonthly,
    required List<BudgetCategory> categories,
    required List<SavingsGoal> goals,
    String preset = 'proportional',
    Map<String, double>? userAllocationPct,
  }) async {
    final disposable = max(0.0, income - fixedMonthly);
    final allocations = <String, double>{};
    final warnings = <String>[];

    // Helper: equal split
    double equalSplit() => categories.isNotEmpty ? disposable / categories.length : 0.0;

    if (userAllocationPct != null && userAllocationPct.isNotEmpty) {
      // Interpret values as fractions (0.0 - 1.0). If they sum != 1, scale them.
      final sumPct = userAllocationPct.values.fold(0.0, (p, e) => p + e);
      final scale = sumPct > 0 ? (1.0 / sumPct) : 0.0;
      for (final c in categories) {
        final pct = (userAllocationPct[c.id] ?? 0.0) * scale;
        allocations[c.id] = pct * disposable;
      }
    } else if (preset == '50-30-20') {
      // Apply 50% needs, 30% wants, 20% savings on income
      final needs = income * 0.5;
      final wants = income * 0.3;
      final savings = income * 0.2;

      // Distribute needs+wants across categories proportionally to allocationPct if present, else equally.
      final pool = needs + wants - fixedMonthly; // fixedMonthly already part of needs; keep a simple approach
      final base = pool > 0 ? pool : disposable;

      final totalCustomPct = categories.fold(0.0, (s, c) => s + c.allocationPct);
      if (totalCustomPct > 0) {
        for (final c in categories) {
          final pct = c.allocationPct / totalCustomPct;
          allocations[c.id] = pct * base;
        }
      } else {
        final per = base > 0 ? base / categories.length : 0.0;
        for (final c in categories) allocations[c.id] = per;
      }

      // suggested savings = savings (cap to disposable)
      final suggestedSavings = min(savings, disposable);
      // ensure allocations + suggestedSavings <= disposable
      final allocSum = allocations.values.fold(0.0, (a, b) => a + b);
      if (allocSum + suggestedSavings > disposable && disposable > 0) {
        final scaleDown = disposable / (allocSum + suggestedSavings);
        allocations.updateAll((k, v) => v * scaleDown);
      }

      return {
        'allocations': allocations,
        'suggestedSavings': suggestedSavings,
        'disposable': disposable,
        'warnings': warnings,
      };
    } else {
      // proportional: use category.allocationPct if present, else equal split
      final totalPct = categories.fold(0.0, (s, c) => s + c.allocationPct);
      if (totalPct > 0) {
        for (final c in categories) allocations[c.id] = (c.allocationPct / totalPct) * disposable;
      } else {
        final per = equalSplit();
        for (final c in categories) allocations[c.id] = per;
      }
    }

    // Compute suggested monthly savings required by goals
    double requiredMonthlyForGoals() {
      double sum = 0.0;
      final now = DateTime.now();
      for (final g in goals) {
        if (g.targetDate == null) continue;
        final monthsLeft = max(1, ((g.targetDate!.difference(now).inDays) / 30).ceil());
        final remaining = max(0.0, g.targetAmount - g.savedAmount);
        sum += (remaining / monthsLeft);
      }
      return sum;
    }

    final requiredSavings = requiredMonthlyForGoals();
    double suggestedSavings = min(requiredSavings, disposable * 0.5); // don't consume more than 50% of disposable by default

    // If allocations sum + suggestedSavings exceed disposable, scale allocations down proportionally
    final allocSum = allocations.values.fold(0.0, (a, b) => a + b);
    if (allocSum + suggestedSavings > disposable && disposable > 0) {
      final availableForAlloc = max(0.0, disposable - suggestedSavings);
      if (allocSum > 0) {
        final scale = availableForAlloc / allocSum;
        allocations.updateAll((k, v) => v * scale);
        warnings.add('Allocations scaled down to fit income after savings');
      } else {
        // nothing to scale
      }
    }

    return {
      'allocations': allocations,
      'suggestedSavings': suggestedSavings,
      'disposable': disposable,
      'warnings': warnings,
    };
  }

  /// Detect overspending on categories. Returns a list of alerts with type and message.
  List<Map<String, dynamic>> detectOverspend(List<BudgetCategory> categories) {
    final alerts = <Map<String, dynamic>>[];
    for (final c in categories) {
      final alloc = c.allocationAmount;
      final spent = c.spentMonthToDate;
      if (alloc <= 0) continue;
      final pct = spent / alloc;
      if (pct >= 1.0) {
        alerts.add({'type': 'hard', 'categoryId': c.id, 'message': '${c.name} has reached 100% of its allocation'});
      } else if (pct >= 0.8) {
        alerts.add({'type': 'soft', 'categoryId': c.id, 'message': '${c.name} has reached 80% of its allocation'});
      }
    }
    return alerts;
  }
}
