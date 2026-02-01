import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/mock_data.dart';
import '../../../core/theme/app_theme.dart';

class BudgetDashboardScreen extends StatelessWidget {
  const BudgetDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgets = MockData.sampleBudgets;
    
    final totalBudget = budgets.fold<double>(
      0,
      (sum, b) => sum + b.limit,
    );
    
    final totalSpent = budgets.fold<double>(
      0,
      (sum, b) => sum + b.spent,
    );

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
          'Budgets',
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
            // Budget Overview
            _buildOverviewSection(totalBudget, totalSpent),
            const SizedBox(height: 32),

            // Budget Items
            _buildBudgetItemsSection(budgets),
            const SizedBox(height: 32),

            // Budget Status Insights
            _buildInsightsSection(budgets),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(double totalBudget, double totalSpent) {
    final percentage = (totalSpent / totalBudget * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Budget',
              style: TextStyle(
                color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${totalBudget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                      'Total Limit',
                      style: TextStyle(
                        color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Spent',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalSpent / totalBudget,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(totalSpent / totalBudget),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItemsSection(List<dynamic> budgets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ...budgets.asMap().entries.map((entry) {
          final index = entry.key;
          final budget = entry.value;
          final isLast = index == budgets.length - 1;
          final percentage = (budget.spent / budget.limit * 100).toStringAsFixed(0);

          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        budget.category,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.darkColor,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(budget.spent / budget.limit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: budget.spent / budget.limit,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(budget.spent / budget.limit),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${budget.spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      if (budget.spent <= budget.limit)
                        Text(
                          '\$${(budget.limit - budget.spent).toStringAsFixed(2)} left',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        Text(
                          '\$${(budget.spent - budget.limit).toStringAsFixed(2)} over',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInsightsSection(List<dynamic> budgets) {
    final overspent = budgets.where((b) => b.spent > b.limit).toList();
    final insights = <String>[];

    if (overspent.isEmpty) {
      insights.add('All budgets are on track');
    } else {
      insights.add('${overspent.length} budget(s) exceeded');
    }

    final remaining = budgets.fold<double>(
      0,
      (sum, b) => sum + (b.limit - b.spent).clamp(0, b.limit),
    );

    if (remaining > 0) {
      insights.add('\$${remaining.toStringAsFixed(2)} remaining overall');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ...insights.map((insight) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
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
                    insight,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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

  Color _getStatusColor(double percentage) {
    if (percentage >= 1.0) return Colors.red;
    if (percentage >= 0.8) return Colors.orange;
    return Colors.green;
  }
}
