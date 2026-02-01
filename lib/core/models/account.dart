// Auto-generated skeleton model for accounts
class AccountModel {
  final String id;
  final String provider;
  final String accountNumberMasked;
  final String currency;
  final double balance;
  final double? availableBalance;

  AccountModel({
    required this.id,
    required this.provider,
    required this.accountNumberMasked,
    required this.currency,
    required this.balance,
    this.availableBalance,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json['id'] as String,
        provider: json['provider'] as String,
        accountNumberMasked: json['accountNumberMasked'] as String? ?? '',
        currency: json['currency'] as String? ?? 'KES',
        balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
        availableBalance: json['availableBalance'] != null ? (json['availableBalance'] as num).toDouble() : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider': provider,
        'accountNumberMasked': accountNumberMasked,
        'currency': currency,
        'balance': balance,
        'availableBalance': availableBalance,
      };
}
