import 'package:flutter_test/flutter_test.dart';
import 'package:smart_savings/core/services/category_mapper.dart';
import 'package:smart_savings/core/models/transaction.dart';

void main() {
  group('CategoryMapper', () {
    test('suggestCategory detects transport from description', () {
      final mapper = CategoryMapper();
      final tx = TransactionModel(
        id: 't1',
        date: DateTime.now(),
        amount: 500.0,
        currency: 'KES',
        rawDescription: 'Uber Kenya Trip',
        source: 'MPESA',
        accountId: 'a1',
        status: 'SETTLED',
      );
      final cat = mapper.suggestCategory(tx);
      expect(cat, 'transport');
    });
  });
}
