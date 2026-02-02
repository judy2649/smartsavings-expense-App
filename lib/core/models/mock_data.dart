import 'account_model.dart';
import 'transaction_model.dart';
import 'budget_model.dart';
import 'savings_goal.dart';

class MockData {
  static final List<Account> sampleAccounts = [
    Account(
      id: 'acc_001',
      userId: 'user_001',
      name: 'Cash Wallet',
      type: 'cash',
      balance: 15000,
      currency: 'KES',
      icon: '💵',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
    ),
    Account(
      id: 'acc_002',
      userId: 'user_001',
      name: 'Primary Bank',
      type: 'bank',
      balance: 85000,
      currency: 'KES',
      icon: '🏦',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now(),
    ),
    Account(
      id: 'acc_003',
      userId: 'user_001',
      name: 'M-Pesa',
      type: 'mobile_money',
      balance: 22200,
      currency: 'KES',
      icon: '📱',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<Transaction> sampleTransactions = [
    Transaction(
      id: 'txn_001',
      accountId: 'acc_001',
      userId: 'user_001',
      type: 'income',
      category: 'Salary',
      description: 'Monthly Salary',
      amount: 50000,
      icon: '💰',
      color: 0xFF10B981,
      date: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: 'txn_002',
      accountId: 'acc_001',
      userId: 'user_001',
      type: 'expense',
      category: 'Food',
      description: 'Grocery Shopping',
      amount: 3200,
      icon: '🛒',
      color: 0xFFFB923C,
      date: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 'txn_003',
      accountId: 'acc_002',
      userId: 'user_001',
      type: 'expense',
      category: 'Transport',
      description: 'Uber Ride',
      amount: 850,
      icon: '🚗',
      color: 0xFF3B82F6,
      date: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 'txn_004',
      accountId: 'acc_001',
      userId: 'user_001',
      type: 'expense',
      category: 'Entertainment',
      description: 'Cinema Tickets',
      amount: 1500,
      icon: '🎬',
      color: 0xFFEC4899,
      date: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 'txn_005',
      accountId: 'acc_003',
      userId: 'user_001',
      type: 'expense',
      category: 'Utilities',
      description: 'Internet Bill',
      amount: 1500,
      icon: '📡',
      color: 0xFF8B5CF6,
      date: DateTime.now().subtract(const Duration(hours: 12)),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Transaction(
      id: 'txn_006',
      accountId: 'acc_002',
      userId: 'user_001',
      type: 'expense',
      category: 'Food',
      description: 'Restaurant Lunch',
      amount: 2750,
      icon: '🍴',
      color: 0xFFFB923C,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  static final List<Budget> sampleBudgets = [
    Budget(
      id: 'bgt_001',
      userId: 'user_001',
      category: 'Food',
      limit: 8000,
      spent: 5950,
      icon: '🍎',
      period: 'weekly',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now(),
    ),
    Budget(
      id: 'bgt_002',
      userId: 'user_001',
      category: 'Transport',
      limit: 4000,
      spent: 850,
      icon: '🚗',
      period: 'weekly',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now(),
    ),
    Budget(
      id: 'bgt_003',
      userId: 'user_001',
      category: 'Entertainment',
      limit: 5000,
      spent: 1500,
      icon: '🎮',
      period: 'weekly',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now(),
    ),
  ];

  static final List<SavingsGoal> sampleGoals = [
    SavingsGoal(
      id: 'goal_001',
      userId: 'user_001',
      name: 'Emergency Fund',
      targetAmount: 100000,
      currentAmount: 45000,
      icon: '🆘',
      priority: 1,
      deadline: DateTime.now().add(const Duration(days: 365)),
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    SavingsGoal(
      id: 'goal_002',
      userId: 'user_001',
      name: 'Vacation Fund',
      targetAmount: 80000,
      currentAmount: 32500,
      icon: '✈️',
      priority: 2,
      deadline: DateTime.now().add(const Duration(days: 180)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    SavingsGoal(
      id: 'goal_003',
      userId: 'user_001',
      name: 'New Laptop',
      targetAmount: 120000,
      currentAmount: 42000,
      icon: '💻',
      priority: 2,
      deadline: DateTime.now().add(const Duration(days: 240)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  static double getTotalBalance() {
    return sampleAccounts.fold(0, (sum, account) => sum + account.balance);
  }

  static double getWeeklySpending() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return sampleTransactions
        .where((t) =>
            t.type == 'expense' &&
            t.date.isAfter(weekAgo) &&
            t.date.isBefore(DateTime.now()))
        .fold(0, (sum, t) => sum + t.amount);
  }

  static double getMonthlySpending() {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    return sampleTransactions
        .where((t) =>
            t.type == 'expense' &&
            t.date.isAfter(monthAgo) &&
            t.date.isBefore(DateTime.now()))
        .fold(0, (sum, t) => sum + t.amount);
  }

  static Map<String, double> getSpendingByCategory() {
    final categories = <String, double>{};
    for (var t in sampleTransactions.where((t) => t.type == 'expense')) {
      categories[t.category] = (categories[t.category] ?? 0) + t.amount;
    }
    return categories;
  }

  static List<Transaction> getRecentTransactions({int count = 5}) {
    final sorted = [...sampleTransactions]
        .where((t) => t.type == 'expense')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(count).toList();
  }
}
