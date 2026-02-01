import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.red),
              title: const Text('Groceries'),
              subtitle: const Text('Today'),
              trailing: const Text('-\$45.50'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.green),
              title: const Text('Salary'),
              subtitle: const Text('Yesterday'),
              trailing: const Text('+\$3,500.00'),
            ),
          ),
        ],
      ),
    );
  }
}
