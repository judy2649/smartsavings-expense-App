class Transaction {
  final String id;
  final String userId;
  final String accountId;
  final String category;
  final String type; // 'income' or 'expense'
  final double amount;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final bool isRecurring;
  final String? recurringPeriod; // 'daily', 'weekly', 'monthly', 'yearly'
  final String? recurringEndDate;
  final String icon;
  final int color;

  Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.category,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.createdAt,
    this.isRecurring = false,
    this.recurringPeriod,
    this.recurringEndDate,
    required this.icon,
    required this.color,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      userId: map['userId'] as String,
      accountId: map['accountId'] as String,
      category: map['category'] as String,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      isRecurring: map['isRecurring'] as bool? ?? false,
      recurringPeriod: map['recurringPeriod'] as String?,
      recurringEndDate: map['recurringEndDate'] as String?,
      icon: map['icon'] as String? ?? '📦',
      color: map['color'] as int? ?? 0xFF6B7280,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'category': category,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isRecurring': isRecurring,
      'recurringPeriod': recurringPeriod,
      'recurringEndDate': recurringEndDate,
      'icon': icon,
      'color': color,
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? category,
    String? type,
    double? amount,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    bool? isRecurring,
    String? recurringPeriod,
    String? recurringEndDate,
    String? icon,
    int? color,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      category: category ?? this.category,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
