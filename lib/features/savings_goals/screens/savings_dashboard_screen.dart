import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/models/mock_data.dart';
import '../../../core/providers/savings_provider.dart';
import '../../../core/models/savings_goal.dart';
import '../../../core/theme/app_theme.dart';

class SavingsDashboardScreen extends StatelessWidget {
  const SavingsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SavingsProvider>(context);
    final goals = provider.goals.isNotEmpty ? provider.goals : MockData.sampleGoals;
    
    final totalGoal = goals.fold<double>(
      0,
      (sum, g) => sum + g.targetAmount,
    );
    
    final totalSaved = goals.fold<double>(
      0,
      (sum, g) => sum + g.currentAmount,
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
          'Savings Goals',
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
            // Savings Overview
            _buildOverviewSection(totalGoal, totalSaved),
            const SizedBox(height: 32),

            // Savings Goals
            _buildGoalsSection(goals),
            const SizedBox(height: 32),

            // Progress Insights
            _buildProgressSection(goals),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context, provider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, SavingsProvider provider) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime? deadline;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Savings Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Goal name')),
            TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Target amount'), keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 30)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 3650)));
                if (picked != null) {
                  deadline = picked;
                }
              },
              child: const Text('Pick deadline'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final target = double.tryParse(amountCtrl.text) ?? 0.0;
              if (name.isEmpty || target <= 0) return;
              final id = 'goal_${DateTime.now().millisecondsSinceEpoch}';
              final goal = SavingsGoal(
                id: id,
                userId: 'user_001',
                name: name,
                targetAmount: target,
                currentAmount: 0.0,
                deadline: deadline ?? DateTime.now().add(const Duration(days: 90)),
                createdAt: DateTime.now(),
              );
              provider.createGoal(goal);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goal created')));
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(double totalGoal, double totalSaved) {
    final percentage = (totalSaved / totalGoal * 100).toStringAsFixed(0);
    final remaining = totalGoal - totalSaved;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Savings',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '\$${totalSaved.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
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
                    '\$${remaining.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'To Save',
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Complete',
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
              value: totalSaved / totalGoal,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(List<dynamic> goals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Goals',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ...goals.asMap().entries.map((entry) {
          final index = entry.key;
          final goal = entry.value;
          final isLast = index == goals.length - 1;
          final percentage =
              (goal.currentAmount / goal.targetAmount * 100).toStringAsFixed(0);

          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        goal.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.darkColor,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.savedAmount / goal.targetAmount,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${goal.savedAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${(goal.targetAmount - goal.savedAmount).toStringAsFixed(2)} remaining',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
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

  Widget _buildProgressSection(List<dynamic> goals) {
    final onTrack =
        goals.where((g) => (g.currentAmount / g.targetAmount) >= 0.5).length;
    final needsAttention =
        goals.where((g) => (g.currentAmount / g.targetAmount) < 0.5).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildProgressBullet(
          '$onTrack goal${onTrack != 1 ? 's' : ''} on track (50%+ saved)',
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildProgressBullet(
          '$needsAttention goal${needsAttention != 1 ? 's' : ''} needs attention',
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildProgressBullet(
          'Keep saving to reach your dreams',
          AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildProgressBullet(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
