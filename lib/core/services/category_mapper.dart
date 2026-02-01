// Skeleton Category Mapper Service
import '../models/transaction.dart';

class CategoryMapper {
  CategoryMapper();

  /// Suggest a category for a transaction using simple heuristics.
  String suggestCategory(TransactionModel tx) {
    final desc = tx.rawDescription.toLowerCase();
    if (desc.contains('supermarket') || desc.contains('grocer') || desc.contains('market')) return 'groceries';
    if (desc.contains('rent')) return 'rent';
    if (desc.contains('uber') || desc.contains('taxi')) return 'transport';
    if (desc.contains('netflix') || desc.contains('spotify')) return 'subscriptions';
    return tx.category ?? 'uncategorized';
  }
}
