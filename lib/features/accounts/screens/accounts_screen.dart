import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Checking Account'),
              subtitle: const Text('Bank of America'),
              trailing: const Text('\$2,500.00'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text('Cash'),
              subtitle: const Text('Personal'),
              trailing: const Text('\$250.00'),
            ),
          ),
        ],
      ),
    );
  }
}
