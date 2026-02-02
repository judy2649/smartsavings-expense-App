class SuggestionService {
  SuggestionService();

  /// Very simple heuristic suggestions based on transactions.
  /// Returns a list of short suggestions for the user.
  List<String> analyzeExpenses(List<dynamic> transactions) {
    if (transactions.isEmpty) return [];

    // Group by category
    final Map<String, double> totals = {};
    double total = 0;
    for (final t in transactions) {
      try {
        final cat = (t.category ?? 'uncategorized').toString();
        final amt = (t.amount is num) ? (t.amount as num).toDouble() : double.tryParse(t.amount.toString()) ?? 0.0;
        totals[cat] = (totals[cat] ?? 0) + amt;
        total += amt;
      } catch (_) {}
    }

    final suggestions = <String>[];
    // If any category is more than 30% of total, suggest review
    totals.forEach((cat, amt) {
      if (total > 0 && amt / total > 0.30) {
        suggestions.add('You spent ${amt.toStringAsFixed(2)} in $cat (>${(amt/total*100).toStringAsFixed(0)}% of recent spending). Consider reviewing or setting a budget.');
      }
    });

    // Overall high spending suggestion
    if (total > 100000) {
      suggestions.add('Your recent spending is high — consider moving surplus into savings goals.');
    }

    if (suggestions.isEmpty) {
      suggestions.add('All looks balanced — keep it up!');
    }

    return suggestions;
  }
}
