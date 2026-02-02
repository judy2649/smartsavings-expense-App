import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/savings_goal.dart';

class SavingsGoalsRepository {
  final FirebaseFirestore _firestore;

  SavingsGoalsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<List<SavingsGoal>> getSavingsGoals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('savings_goals')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SavingsGoal.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SavingsGoal>> getSavingsGoalsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('savings_goals')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SavingsGoal.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> addSavingsGoal(String userId, SavingsGoal goal) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('savings_goals')
          .doc(goal.id)
          .set(goal.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSavingsGoal(String userId, SavingsGoal goal) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('savings_goals')
          .doc(goal.id)
          .update(goal.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSavingsGoal(String userId, String goalId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('savings_goals')
          .doc(goalId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getTotalSavingsTargets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('savings_goals')
          .where('isActive', isEqualTo: true)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['targetAmount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      rethrow;
    }
  }
}
