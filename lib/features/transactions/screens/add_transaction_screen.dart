import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/transaction_id_generator.dart';
import '../../../core/models/transaction_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/transactions_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'expense';
  final _amountCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _categoryCtrl.dispose();
    _descriptionCtrl.dispose();
    _accountCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final txProvider = context.read<TransactionsProvider>();

    final user = auth.user;
    final userId = user?.uid ?? 'guest';

    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0.0;
    final accountId = _accountCtrl.text.isNotEmpty ? _accountCtrl.text : 'default_account';

    final id = generateTransactionId(date: _date, amount: amount, accountId: accountId);

    final tx = Transaction(
      id: id,
      userId: userId,
      accountId: accountId,
      category: _categoryCtrl.text.isNotEmpty ? _categoryCtrl.text : 'uncategorized',
      type: _type,
      amount: amount,
      description: _descriptionCtrl.text,
      date: _date,
      createdAt: DateTime.now(),
      isRecurring: false,
      recurringPeriod: null,
      recurringEndDate: null,
      icon: _type == 'expense' ? '💸' : '💰',
      color: 0xFF6B7280,
    );

    await txProvider.addTransaction(userId, tx);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction added')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'expense'),
                decoration: InputDecoration(labelText: 'Type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                decoration: InputDecoration(labelText: 'Amount', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter an amount' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryCtrl,
                decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountCtrl,
                decoration: InputDecoration(labelText: 'Account ID (e.g., MPESA number)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: Text('Date: ${_date.toLocal().toIso8601String().split('T').first}')),
                TextButton(onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (d != null) setState(() => _date = d);
                }, child: const Text('Change'))
              ]),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: const Text('Add Transaction'))),
            ],
          ),
        ),
      ),
    );
  }
}
