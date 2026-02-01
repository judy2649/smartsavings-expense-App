class Budget {
  final String id;
  final String userId;
  final String category;
  final double limit;
  final double spent;
  final String period; // 'weekly', 'monthly'
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final String? icon;

  Budget({
    required this.id,
    required this.userId,
    required this.category,
    required this.limit,
    required this.spent,
    required this.period,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    required this.createdAt,
    this.icon,
  });

  double get remainingAmount => (limit - spent).clamp(0.0, limit);
  double get percentageUsed => (spent / limit * 100).clamp(0.0, 100.0);
  bool get isExceeded => spent > limit;
  bool get isNearingLimit => percentageUsed >= 80;

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as String,
      userId: map['userId'] as String,
      category: map['category'] as String,
      limit: (map['limit'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
      period: map['period'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(map['createdAt'] as String),
      icon: map['icon'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'limit': limit,
      'spent': spent,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'icon': icon,
    };
  }

  Budget copyWith({
    String? id,
    String? userId,
    String? category,
    double? limit,
    double? spent,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
