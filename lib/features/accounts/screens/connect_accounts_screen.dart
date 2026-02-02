import 'package:flutter/material.dart';

class ConnectAccountsScreen extends StatefulWidget {
  const ConnectAccountsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectAccountsScreen> createState() => _ConnectAccountsScreenState();
}

class _ConnectAccountsScreenState extends State<ConnectAccountsScreen> {
  late TextEditingController _accountNumberCtrl;
  late TextEditingController _accountTypeCtrl;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _accountNumberCtrl = TextEditingController();
    _accountTypeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _accountNumberCtrl.dispose();
    _accountTypeCtrl.dispose();
    super.dispose();
  }

  Future<void> _connectAccount() async {
    if (_accountNumberCtrl.text.isEmpty || _accountTypeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isConnecting = true);

    try {
      // Simulate account connection delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_accountTypeCtrl.text} account (${_accountNumberCtrl.text}) connected successfully!',
            ),
          ),
        );

        _accountNumberCtrl.clear();
        _accountTypeCtrl.clear();
        setState(() => _isConnecting = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting account: $e')),
        );
        setState(() => _isConnecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Accounts'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link Your Financial Accounts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Connect your M-Pesa, bank accounts, and other financial institutions to automatically sync transactions.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _accountTypeCtrl.text.isEmpty ? null : _accountTypeCtrl.text,
              items: const [
                DropdownMenuItem(value: 'M-Pesa', child: Text('M-Pesa')),
                DropdownMenuItem(value: 'KCB Bank', child: Text('KCB Bank')),
                DropdownMenuItem(value: 'Equity Bank', child: Text('Equity Bank')),
                DropdownMenuItem(value: 'Standard Chartered', child: Text('Standard Chartered')),
                DropdownMenuItem(value: 'Co-operative Bank', child: Text('Co-operative Bank')),
              ],
              onChanged: (value) {
                setState(() {
                  _accountTypeCtrl.text = value ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'Account Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accountNumberCtrl,
              decoration: InputDecoration(
                labelText: 'Account Number / Phone',
                hintText: 'e.g., 0712345678 or 1234567890',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isConnecting ? null : _connectAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isConnecting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Connect Account',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Connected Accounts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No accounts connected yet',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
