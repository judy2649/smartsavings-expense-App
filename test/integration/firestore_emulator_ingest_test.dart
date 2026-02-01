import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_savings/core/repositories/transactions_repository.dart';
import 'package:smart_savings/core/models/transaction_model.dart' as app_tx;

// Integration test that requires the Firestore emulator to be running.
// Before running this test start the emulator:
//   firebase emulators:start --only firestore
// Then run:
//   flutter test test/integration/firestore_emulator_ingest_test.dart

void main() async {
  const emulatorHost = 'localhost';
  const emulatorPort = 8080; // default Firestore emulator port

  // Check emulator availability before defining tests so we can use `skip`.
  var emulatorAvailable = false;
  try {
    final socket = await Socket.connect(emulatorHost, emulatorPort, timeout: const Duration(milliseconds: 500));
    socket.destroy();
    emulatorAvailable = true;
  } catch (_) {
    emulatorAvailable = false;
  }

  if (emulatorAvailable) {
    // Initialize Firebase with dummy options (emulator ignores these values)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'fake',
        appId: '1:234:android:fake',
        messagingSenderId: 'fake',
        projectId: 'demo-project',
      ),
    );

    // Point Firestore to the emulator
    FirebaseFirestore.instance.settings = const Settings(
      host: '$emulatorHost:$emulatorPort',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }

  test(
    'concurrent addTransaction is idempotent (only one created)',
    () async {
    final firestore = FirebaseFirestore.instance;
    final repo = TransactionsRepository(firestore: firestore);
    final userId = 'integration-user-1';

    // Clean any existing docs for the user (best-effort)
    final colRef = firestore.collection('users').doc(userId).collection('transactions');
    final existing = await colRef.get();
    for (final d in existing.docs) {
      await d.reference.delete();
    }

    final tx = app_tx.Transaction(
      id: 'integration-test-tx',
      userId: userId,
      accountId: 'acc-1',
      category: 'test',
      type: 'expense',
      amount: 42.0,
      description: 'Integration test tx',
      date: DateTime.now(),
      createdAt: DateTime.now(),
      isRecurring: false,
      recurringPeriod: null,
      recurringEndDate: null,
      icon: '💳',
      color: 0xFF000000,
    );

    // Fire multiple concurrent attempts to insert the same transaction id.
    final futures = List.generate(8, (_) => repo.addTransaction(userId, tx));
    final results = await Future.wait(futures);

    final createdCount = results.where((r) => r == true).length;
    expect(createdCount, 1);

    final snapshot = await colRef.get();
    expect(snapshot.docs.length, 1);

    // Cleanup
    for (final d in snapshot.docs) {
      await d.reference.delete();
    }
    },
    timeout: const Timeout(Duration(seconds: 30)),
    skip: !emulatorAvailable ? 'Firestore emulator not reachable at $emulatorHost:$emulatorPort' : false,
  );
}
