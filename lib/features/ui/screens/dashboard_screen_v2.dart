import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../transactions/providers/transactions_provider.dart';

class DashboardScreenV2 extends StatefulWidget {
  const DashboardScreenV2({super.key});

  @override
  State<DashboardScreenV2> createState() => _DashboardScreenV2State();
}

class _DashboardScreenV2State extends State<DashboardScreenV2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransactionsProvider>(context, listen: false);
      provider.loadTransactions('user_001');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F4788),
        actions: const [Icon(Icons.notifications, color: Colors.white)],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTotalBalanceCard(),
              const SizedBox(height: 20),
              _buildQuickActionsRow(context),
              const SizedBox(height: 20),
              _buildBudgetsPreview(),
              const SizedBox(height: 20),
              _buildSpendingBreakdown(),
              const SizedBox(height: 20),
              _buildRecentTransactions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard() {
    return Consumer<TransactionsProvider>(
      builder: (context, provider, _) {
        double balance = 0;
        for (var txn in provider.transactions) {
          if (txn.type == 'income') balance += txn.amount;
          else if (txn.type == 'expense') balance -= txn.amount;
        }

        return Card(
          color: const Color(0xFF2196F3),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Balance', style: TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 12),
                Text('\$${balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Text(balance > 0 ? '✓ Positive Balance' : '○ No transactions', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          context,
          Icons.add,
          'Add Expense',
          const Color(0xFFFF6B6B),
          () => context.push('/home/transactions/add'),
        ),
        _buildActionButton(
          context,
          Icons.pie_chart,
          'Add Budget',
          const Color(0xFF4CAF50),
          () => context.push('/home/budgets/add'),
        ),
        _buildActionButton(
          context,
          Icons.flag,
          'Add Goal',
          const Color(0xFFFFC107),
          () => context.push('/home/savings-goals/add'),
        ),
        _buildActionButton(
          context,
          Icons.link,
          'Connect Account',
          const Color(0xFF9C27B0),
          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account linking disabled in demo'))),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBudgetsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Budget Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 200,
              child: Card(
                color: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(['Groceries', 'Transport', 'Entertainment'][index], style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                      const Spacer(),
                      LinearProgressIndicator(
                        value: [0.6, 0.4, 0.8][index],
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text('${(100 * [0.6, 0.4, 0.8][index]).toStringAsFixed(0)}% used', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingBreakdown() {
    return Card(
      color: const Color(0xFFFFC107),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: Icon(Icons.pie_chart, size: 48, color: Colors.white),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Spending Categories', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('• Food - 32%', style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text('• Transport - 18%', style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text('• Bills - 12%', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            TextButton(
              onPressed: () => context.push('/home/transactions'),
              child: const Text('View All', style: TextStyle(color: AppTheme.primaryColor)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<TransactionsProvider>(
          builder: (context, provider, _) {
            final recentTxns = provider.transactions.take(5);
            if (recentTxns.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('No transactions yet. Add one to get started!', style: TextStyle(color: Colors.grey))),
                ),
              );
            }
            return Column(
              children: recentTxns.map((txn) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: txn.type == 'income' ? const Color(0xFF4CAF50) : const Color(0xFFFF6B6B),
                      child: Icon(
                        txn.type == 'income' ? Icons.trending_up : Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(txn.category, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                    subtitle: Text(txn.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Text(
                      '${txn.type == 'income' ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: txn.type == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
