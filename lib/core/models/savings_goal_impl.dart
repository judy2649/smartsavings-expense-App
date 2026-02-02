class SavingsGoal {
  final String id;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String? description;
  final String? icon;
  final int priority;
  final bool isActive;
  final DateTime createdAt;

  SavingsGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.description,
    this.icon,
    this.priority = 2,
    this.isActive = true,
    required this.createdAt,
  });

  double get remainingAmount => (targetAmount - currentAmount).clamp(0.0, targetAmount);
  double get percentageCompleted => (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  bool get isCompleted => currentAmount >= targetAmount;
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  factory SavingsGoal.fromMap(Map<String, dynamic> map) => SavingsGoal(
        id: map['id'] as String,
        userId: map['userId'] as String,
        name: map['name'] as String,
        targetAmount: (map['targetAmount'] as num).toDouble(),
        currentAmount: (map['currentAmount'] as num).toDouble(),
        deadline: DateTime.parse(map['deadline'] as String),
        description: map['description'] as String?,
        icon: map['icon'] as String?,
        priority: map['priority'] as int? ?? 2,
        isActive: map['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'name': name,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'deadline': deadline.toIso8601String(),
        'description': description,
        'icon': icon,
        'priority': priority,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
      };

  SavingsGoal copyWith({
    String? id,
    String? userId,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? description,
    String? icon,
    int? priority,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
