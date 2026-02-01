// Aggregator Service (basic normalization + deduplication)
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../utils/transaction_id_generator.dart';

class AggregatorService {
  AggregatorService();

  /// Normalize a provider-specific M-Pesa payload into TransactionModel-like map.
  /// Accepts a map representing a single M-Pesa transaction (common fields) and returns a normalized map.
  Map<String, dynamic> normalizeMpesa(Map<String, dynamic> p) {
    // Common M-Pesa fields (examples): 'TransactionType', 'TransID', 'TransTime', 'TransAmount', 'MSISDN', 'BusinessShortCode', 'ThirdPartyTransID', 'OrgAccountBalance', 'ReceiptNumber'
    final rawTxId = p['TransID'] ?? p['ReceiptNumber'] ?? p['trans_id'];
    final rawDesc = p['TransactionType'] ?? p['Raw'] ?? p['description'] ?? p.toString();
    String dateStr = p['TransTime'] ?? p['transaction_date'] ?? p['date'] ?? '';
    DateTime date;
    try {
      // Try common formats: yyyyMMddHHmmss or ISO
      if (RegExp(r'^\d{14}\$').hasMatch(dateStr)) {
        // yyyyMMddHHmmss
        final fmt = DateFormat('yyyyMMddHHmmss');
        date = fmt.parse(dateStr);
      } else if (dateStr.isNotEmpty) {
        date = DateTime.parse(dateStr);
      } else {
        date = DateTime.now();
      }
    } catch (_) {
      date = DateTime.now();
    }

    final amountRaw = p['TransAmount'] ?? p['amount'] ?? p['Value'] ?? 0;
    final amount = (amountRaw is String) ? double.tryParse(amountRaw.replaceAll(',', '')) ?? 0.0 : (amountRaw as num?)?.toDouble() ?? 0.0;

    final merchant = p['BusinessShortCode'] ?? p['Receiver'] ?? p['merchant'] ?? null;

    final txId = rawTxId?.toString() ?? generateTransactionId(date: date, amount: amount, accountId: p['MSISDN'] ?? p['Account'] ?? '', merchant: merchant?.toString());

    return {
      'txId': txId,
      'date': date.toIso8601String(),
      'amount': amount,
      'currency': p['Currency'] ?? 'KES',
      'merchant': merchant,
      'rawDescription': rawDesc.toString(),
      'category': null,
      'source': 'MPESA',
      'accountId': p['MSISDN'] ?? p['Account'] ?? '',
      'status': 'SETTLED',
      'metadata': p,
    };
  }

  /// Ingest generic payloads and normalize. Supports source-specific normalization (e.g., 'MPESA').
  Future<List<TransactionModel>> ingestAndNormalize(List<Map<String, dynamic>> payloads, {required String source}) async {
    final out = <TransactionModel>[];
    for (final p in payloads) {
      final norm = (source.toUpperCase() == 'MPESA') ? normalizeMpesa(p) : _genericNormalize(p, source);
      final tx = TransactionModel.fromJson(norm);
      out.add(tx);
    }
    // Deduplication would typically occur against stored transactions; here we return normalized list.
    return out;
  }

  Map<String, dynamic> _genericNormalize(Map<String, dynamic> p, String source) {
    final dateStr = (p['date'] ?? p['timestamp'] ?? DateTime.now().toIso8601String()).toString();
    DateTime date;
    try {
      date = DateTime.parse(dateStr);
    } catch (_) {
      date = DateTime.now();
    }

    final amt = (p['amount'] is String) ? double.tryParse((p['amount'] as String).replaceAll(',', '')) ?? 0.0 : (p['amount'] as num?)?.toDouble() ?? 0.0;

    final rawId = p['txId'] ?? p['id'];

    return {
      'txId': rawId?.toString() ?? generateTransactionId(date: date, amount: amt, accountId: p['accountId'] ?? '', merchant: p['merchant']?.toString()),
      'date': date.toIso8601String(),
      'amount': amt,
      'currency': p['currency'] ?? 'KES',
      'merchant': p['merchant'] ?? p['description'] ?? null,
      'rawDescription': p['rawDescription'] ?? p['description'] ?? '',
      'category': p['category'] ?? null,
      'source': source,
      'accountId': p['accountId'] ?? '',
      'status': p['status'] ?? 'SETTLED',
      'metadata': p,
    };
  }

  /// Simple in-memory dedupe: removes transactions with identical txId or same (date, amount, accountId).
  List<TransactionModel> dedupe(List<TransactionModel> incoming, List<TransactionModel> existing) {
    final existingKeys = <String>{};
    for (final e in existing) {
      existingKeys.add(e.id);
      existingKeys.add('${e.date.toIso8601String()}|${e.amount.toStringAsFixed(2)}|${e.accountId}');
    }

    final out = <TransactionModel>[];
    for (final t in incoming) {
      final key = '${t.id}';
      final approx = '${t.date.toIso8601String()}|${t.amount.toStringAsFixed(2)}|${t.accountId}';
      if (existingKeys.contains(key) || existingKeys.contains(approx)) {
        // skip duplicate
        continue;
      }
      out.add(t);
    }
    return out;
  }
}
