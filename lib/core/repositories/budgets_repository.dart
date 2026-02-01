import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

class BudgetsRepository {
  final FirebaseFirestore _firestore;

  BudgetsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<List<Budget>> getBudgets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Budget.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Budget>> getBudgetsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Budget.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> addBudget(String userId, Budget budget) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(budget.id)
          .set(budget.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBudget(String userId, Budget budget) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(budget.id)
          .update(budget.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBudget(String userId, String budgetId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(budgetId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<Budget?> getBudgetByCategory(String userId, String category) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Budget.fromMap({...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
