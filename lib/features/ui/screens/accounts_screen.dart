import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  static const String routeName = '/accounts';
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(onPressed: null, icon: const Icon(Icons.link), label: const Text('Connect Account (disabled)')),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.account_balance_wallet)),
                    title: Text(index == 0 ? 'M-PESA' : 'Account ${index}'),
                    subtitle: const Text('Synced • Last 10m'),
                    trailing: Text('KSH ${(index + 1) * 1234}'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
