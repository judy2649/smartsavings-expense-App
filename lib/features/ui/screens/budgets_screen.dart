import 'package:flutter/material.dart';

class BudgetsScreen extends StatelessWidget {
  static const String routeName = '/budgets';
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Create Budget')),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Budget ${index + 1}'),
                      subtitle: const Text('Monthly • Groceries'),
                      trailing: const Text('60%'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
