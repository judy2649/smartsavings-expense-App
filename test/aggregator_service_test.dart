import 'package:flutter_test/flutter_test.dart';
import 'package:smart_savings/core/services/aggregator_service.dart';

void main() {
  group('AggregatorService', () {
    test('normalizeMpesa maps common fields', () async {
      final svc = AggregatorService();
      final payload = {
        'TransID': 'ABC123',
        'TransTime': '20230101123045',
        'TransAmount': '1500',
        'MSISDN': '+254700000000',
        'BusinessShortCode': '123456',
        'TransactionType': 'Pay Bill',
      };

      final normalized = svc.normalizeMpesa(payload);
      expect(normalized['txId'], 'ABC123');
      expect(normalized['source'], 'MPESA');
      expect(normalized['accountId'], '+254700000000');
      expect(normalized['amount'], 1500);
      expect(normalized['merchant'], '123456');
    });
  });
}
