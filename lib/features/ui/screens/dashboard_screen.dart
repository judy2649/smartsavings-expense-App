import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardScreen({Key? key}) : super(key: key);

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
            children: const [
              _BalanceCard(),
              SizedBox(height: 16),
              _QuickActionsRow(),
              SizedBox(height: 16),
              _BudgetsPreview(),
              SizedBox(height: 16),
              _SpendingBreakdown(),
              SizedBox(height: 16),
              _RecentTransactionsPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2196F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Total balance', style: TextStyle(fontSize: 14, color: Colors.white70)),
            SizedBox(height: 8),
            Text('\$12,345.67', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
            SizedBox(height: 4),
            Text('All accounts • Synced 3m ago', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget action(IconData icon, String label) => Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF1F4788),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        action(Icons.add, 'Add'),
        action(Icons.pie_chart, 'Budget'),
        action(Icons.flag, 'Goal'),
        action(Icons.link, 'Connect'),
      ],
    );
  }
}

class _BudgetsPreview extends StatelessWidget {
  const _BudgetsPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: 220,
          child: Card(
            color: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Groceries', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  Spacer(),
                  LinearProgressIndicator(value: 0.6, backgroundColor: Colors.white30, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  SizedBox(height: 8),
                  Text('KSH 4,200 left', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpendingBreakdown extends StatelessWidget {
  const _SpendingBreakdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFC107),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: const [
            SizedBox(width: 120, height: 120, child: Center(child: Icon(Icons.pie_chart, size: 48, color: Colors.white))),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top categories', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('• Food — 32%', style: TextStyle(color: Colors.white)),
                  Text('• Transport — 18%', style: TextStyle(color: Colors.white)),
                  Text('• Bills — 12%', style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RecentTransactionsPlaceholder extends StatelessWidget {
  const _RecentTransactionsPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        4,
        (i) => Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF3F51B5),
                child: Icon(Icons.store, color: Colors.white),
              ),
              title: Text('Merchant ${i + 1}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
              subtitle: const Text('Category • Today', style: TextStyle(color: Colors.grey)),
              trailing: Text('- KSH ${20 + i * 50}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
