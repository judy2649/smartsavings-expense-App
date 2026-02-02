import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/transactions';
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search merchant, amount, note',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.receipt)),
                  title: Text('Merchant ${index + 1}'),
                  subtitle: const Text('Category • Today'),
                  trailing: Text('- KSH ${50 + index * 10}'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(context: context, builder: (_) => const AddTransactionModal()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTransactionModal extends StatelessWidget {
  const AddTransactionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add Transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Amount')),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Merchant')),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Category')),
            const Spacer(),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
