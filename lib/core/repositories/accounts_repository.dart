import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/account_model.dart';

class AccountsRepository {
  final FirebaseFirestore _firestore;

  AccountsRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  Future<List<Account>> getAccounts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Account.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Account>> getAccountsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Account.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<Account?> getAccount(String userId, String accountId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .doc(accountId)
          .get();
      
      if (doc.exists) {
        return Account.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addAccount(String userId, Account account) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .doc(account.id)
          .set(account.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAccount(String userId, Account account) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .doc(account.id)
          .update(account.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String userId, String accountId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .doc(accountId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getTotalBalance(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .get();
      
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['balance'] as num).toDouble();
      }
      return total;
    } catch (e) {
      rethrow;
    }
  }
}
