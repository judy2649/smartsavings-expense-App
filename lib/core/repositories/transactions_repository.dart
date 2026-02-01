import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'dart:math';
import '../models/transaction_model.dart';

class TransactionsRepository {
  final FirebaseFirestore _firestore;

  TransactionsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<List<Transaction>> getTransactions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? type,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions');

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      final snapshot = await query
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Transaction.fromMap({...doc.data() as Map, 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Transaction>> getTransactionsStream(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');

    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: endDate);
    }

    return query
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromMap({...doc.data() as Map, 'id': doc.id}))
            .toList());
  }

  /// Adds a transaction if it does not already exist (idempotent).
  /// Returns true if the transaction was created, false if it already existed.
  Future<bool> addTransaction(String userId, Transaction transaction) async {
    // Retry with exponential backoff for transient failures.
    const int maxAttempts = 4;
    const int baseDelayMs = 200;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .doc(transaction.id);

        // Use a Firestore transaction to ensure atomic check-and-create (avoids race conditions).
        final created = await _firestore.runTransaction<bool>((tx) async {
          final snapshot = await tx.get(docRef);
          if (snapshot.exists) {
            return false;
          }
          tx.set(docRef, transaction.toMap());
          return true;
        });

        return created;
      } catch (e) {
        // For transient errors retry; for others rethrow after exhausting attempts.
        final isLast = attempt == maxAttempts - 1;
        // Simple heuristic: retry on all exceptions but stop after max attempts.
        if (isLast) {
          // Log final failure
          print('[TransactionsRepository] addTransaction failed after $maxAttempts attempts: ${e.toString()}');
          rethrow;
        }

        // Exponential backoff with jitter to avoid thundering herd.
        final jitter = Random().nextInt(100); // 0-99 ms
        final delayMs = baseDelayMs * (1 << attempt) + jitter;
        print('[TransactionsRepository] addTransaction attempt=${attempt + 1} failed, retrying in ${delayMs}ms: ${e.toString()}');
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    // Should not reach here, but return false defensively.
    return false;
  }

  Future<void> updateTransaction(String userId, Transaction transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String userId, String transactionId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getTotalExpenses(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .where('type', isEqualTo: 'expense');

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['amount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      rethrow;
    }
  }
}
