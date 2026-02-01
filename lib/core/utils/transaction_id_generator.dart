import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Generate a stable transaction id fingerprint from key fields.
/// Uses sha256(dateIso|amount|accountId|merchant).
String generateTransactionId({required DateTime date, required double amount, required String accountId, String? merchant}) {
  final merchantPart = merchant ?? '';
  final input = '${date.toIso8601String()}|${amount.toStringAsFixed(2)}|$accountId|$merchantPart';
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
