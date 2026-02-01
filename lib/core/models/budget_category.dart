// Auto-generated skeleton model for budget categories
class BudgetCategory {
  final String id;
  final String name;
  final double allocationPct;
  final double allocationAmount;
  final double spentMonthToDate;
  final List<String>? alerts;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.allocationPct,
    required this.allocationAmount,
    required this.spentMonthToDate,
    this.alerts,
  });

  factory BudgetCategory.fromJson(Map<String, dynamic> json) => BudgetCategory(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Category',
        allocationPct: (json['allocationPct'] as num?)?.toDouble() ?? 0.0,
        allocationAmount: (json['allocationAmount'] as num?)?.toDouble() ?? 0.0,
        spentMonthToDate: (json['spentMonthToDate'] as num?)?.toDouble() ?? 0.0,
        alerts: (json['alerts'] as List<dynamic>?)?.map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'allocationPct': allocationPct,
        'allocationAmount': allocationAmount,
        'spentMonthToDate': spentMonthToDate,
        'alerts': alerts,
      };
}
