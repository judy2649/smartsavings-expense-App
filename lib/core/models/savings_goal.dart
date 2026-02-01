// Auto-generated skeleton model for savings goals
class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? targetDate;
  final double? monthlyContributionSuggested;
  final int priority;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    this.targetDate,
    this.monthlyContributionSuggested,
    this.priority = 1,
  });

  factory SavingsGoal.fromJson(Map<String, dynamic> json) => SavingsGoal(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Goal',
        targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
        savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0.0,
        targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate'] as String) : null,
        monthlyContributionSuggested: json['monthlyContributionSuggested'] != null ? (json['monthlyContributionSuggested'] as num).toDouble() : null,
        priority: json['priority'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'targetAmount': targetAmount,
        'savedAmount': savedAmount,
        'targetDate': targetDate?.toIso8601String(),
        'monthlyContributionSuggested': monthlyContributionSuggested,
        'priority': priority,
      };
}
