import 'package:flutter/material.dart';
// Account linking disabled in demo; no provider imports required

class ConnectAccountsScreen extends StatefulWidget {
  const ConnectAccountsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectAccountsScreen> createState() => _ConnectAccountsScreenState();
}

class _ConnectAccountsScreenState extends State<ConnectAccountsScreen> {
  // Account linking disabled in this demo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Accounts')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account linking is disabled',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'For safety and to avoid accidental data import in this demo environment, account linking and automated transaction imports are disabled.\n\nIf you need to test imports, please use a dedicated integration environment or enable imports explicitly in the codebase.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: null,
              child: const Text('Connect (disabled)'),
            ),
          ],
        ),
      ),
    );
  }
}
