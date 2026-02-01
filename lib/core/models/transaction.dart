// Auto-generated skeleton model for transactions
class TransactionModel {
  final String id;
  final DateTime date;
  final DateTime? postedDate;
  final double amount;
  final String currency;
  final String? merchant;
  final String rawDescription;
  final String? category;
  final String source;
  final String accountId;
  final String status;

  TransactionModel({
    required this.id,
    required this.date,
    this.postedDate,
    required this.amount,
    required this.currency,
    this.merchant,
    required this.rawDescription,
    this.category,
    required this.source,
    required this.accountId,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['txId'] as String,
        date: DateTime.parse(json['date'] as String),
        postedDate: json['postedDate'] != null ? DateTime.parse(json['postedDate'] as String) : null,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        merchant: json['merchant'] as String?,
        rawDescription: json['rawDescription'] as String? ?? '',
        category: json['category'] as String?,
        source: json['source'] as String? ?? 'MANUAL',
        accountId: json['accountId'] as String? ?? '',
        status: json['status'] as String? ?? 'PENDING',
      );

  Map<String, dynamic> toJson() => {
        'txId': id,
        'date': date.toIso8601String(),
        'postedDate': postedDate?.toIso8601String(),
        'amount': amount,
        'currency': currency,
        'merchant': merchant,
        'rawDescription': rawDescription,
        'category': category,
        'source': source,
        'accountId': accountId,
        'status': status,
      };
}
