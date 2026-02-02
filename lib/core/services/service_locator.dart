import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../repositories/auth_repository.dart';
import '../repositories/accounts_repository.dart';
import '../repositories/transactions_repository.dart';
import '../repositories/budgets_repository.dart';
import '../repositories/savings_goals_repository.dart';
import 'aggregator_service.dart';
import 'budget_engine_service.dart';
import 'suggestion_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Firebase instances
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(auth: getIt<FirebaseAuth>()),
  );

  getIt.registerSingleton<AccountsRepository>(
    AccountsRepository(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerSingleton<TransactionsRepository>(
    TransactionsRepository(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerSingleton<BudgetsRepository>(
    BudgetsRepository(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerSingleton<SavingsGoalsRepository>(
    SavingsGoalsRepository(firestore: getIt<FirebaseFirestore>()),
  );

  // Core services
  getIt.registerLazySingleton<BudgetEngineService>(() => BudgetEngineService());
  getIt.registerLazySingleton<AggregatorService>(() => AggregatorService());
  // Suggestion / insights service
  getIt.registerLazySingleton(() => SuggestionService());
}
