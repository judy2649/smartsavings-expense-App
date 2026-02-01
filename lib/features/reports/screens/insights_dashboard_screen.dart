import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/mock_data.dart';
import '../../../core/theme/app_theme.dart';

class InsightsDashboardScreen extends StatelessWidget {
  const InsightsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactions = MockData.sampleTransactions;
    final budgets = MockData.sampleBudgets;
    final goals = MockData.sampleGoals;

    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        backgroundColor: AppTheme.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Insights',
          style: TextStyle(
            color: AppTheme.darkColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spending Insights
            _buildSpendingInsights(transactions),
            const SizedBox(height: 32),

            // Budget Insights
            _buildBudgetInsights(budgets),
            const SizedBox(height: 32),

            // Savings Insights
            _buildSavingsInsights(goals),
            const SizedBox(height: 32),

            // Recommendations
            _buildRecommendations(transactions, budgets, goals),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingInsights(List<dynamic> transactions) {
    final expenses = transactions.where((t) => t.type == 'expense').toList();
    final income = transactions.where((t) => t.type == 'income').toList();

    final totalExpenses =
        expenses.fold<double>(0, (sum, t) => sum + t.amount);
    final totalIncome = income.fold<double>(0, (sum, t) => sum + t.amount);

    final savingsRate =
        ((totalIncome - totalExpenses) / totalIncome * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending Overview',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Average Monthly Income',
          '\$${totalIncome.toStringAsFixed(2)}',
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          'Average Monthly Spending',
          '\$${totalExpenses.toStringAsFixed(2)}',
          Colors.red,
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          'Savings Rate',
          '$savingsRate%',
          AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildBudgetInsights(List<dynamic> budgets) {
    final onTrack = budgets.where((b) => b.spent <= b.limit).length;
    final exceeded = budgets.where((b) => b.spent > b.limit).length;
    final utilizationRate = (budgets.fold<double>(
            0, (sum, b) => sum + (b.spent / b.limit)) /
        budgets.length *
        100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget Performance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSmallMetric(
                'On Track',
                onTrack.toString(),
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallMetric(
                'Exceeded',
                exceeded.toString(),
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallMetric(
                'Avg Usage',
                '${utilizationRate.toStringAsFixed(0)}%',
                AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsInsights(List<dynamic> goals) {
    final totalGoal = goals.fold<double>(0, (sum, g) => sum + g.targetAmount);
    final totalSaved =
        goals.fold<double>(0, (sum, g) => sum + g.savedAmount);
    final completionRate = (totalSaved / totalGoal * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Savings Goals',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Total Saved',
          '\$${totalSaved.toStringAsFixed(2)}',
          AppTheme.primaryColor,
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          'Target Amount',
          '\$${totalGoal.toStringAsFixed(2)}',
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          'Overall Progress',
          '$completionRate%',
          AppTheme.tertiaryColor,
        ),
      ],
    );
  }

  Widget _buildRecommendations(
    List<dynamic> transactions,
    List<dynamic> budgets,
    List<dynamic> goals,
  ) {
    final recommendations = <String>[];

    final expenses = transactions.where((t) => t.type == 'expense').toList();
    final highestCategory = <String, double>{};
    for (var expense in expenses) {
      highestCategory[expense.category] =
          (highestCategory[expense.category] ?? 0) + expense.amount;
    }

    if (highestCategory.isNotEmpty) {
      final top = highestCategory.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      recommendations.add(
        'Consider reducing ${top.key} spending (your highest expense category)',
      );
    }

    final exceeded = budgets.where((b) => b.spent > b.limit).toList();
    if (exceeded.isNotEmpty) {
      recommendations.add(
        '${exceeded.length} budget(s) exceeded - review and adjust limits',
      );
    }

    if (exceeded.isEmpty) {
      recommendations.add('Great job! All budgets are within limits');
    }

    final slowGoals =
        goals.where((g) => (g.savedAmount / g.targetAmount) < 0.3).toList();
    if (slowGoals.isNotEmpty) {
      recommendations.add(
        'Increase savings for ${slowGoals.first.name} - only ${(slowGoals.first.savedAmount / slowGoals.first.targetAmount * 100).toStringAsFixed(0)}% complete',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ...recommendations.map((rec) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rec,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInsightCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
