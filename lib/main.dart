import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/services/service_locator.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/accounts/providers/accounts_provider.dart';
import 'features/transactions/providers/transactions_provider.dart';
import 'features/budgets/providers/budgets_provider.dart';
import 'features/savings_goals/providers/savings_goals_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Setup service locator
  setupServiceLocator();
  
  runApp(const SmartSavingsApp());
}

class SmartSavingsApp extends StatelessWidget {
  const SmartSavingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AccountsProvider()),
        ChangeNotifierProvider(create: (_) => TransactionsProvider()),
        ChangeNotifierProvider(create: (_) => BudgetsProvider()),
        ChangeNotifierProvider(create: (_) => SavingsGoalsProvider()),
      ],
      child: _Background(child: MaterialApp.router(
          title: 'Smart Savings',
          theme: AppTheme.lightTheme.copyWith(scaffoldBackgroundColor: Colors.transparent),
          darkTheme: AppTheme.darkTheme.copyWith(scaffoldBackgroundColor: Colors.transparent),
          themeMode: ThemeMode.light,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final Widget child;
  const _Background({required this.child});

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _assetExists('assets/images/background.jpg'),
      builder: (context, snapshot) {
        final useAsset = snapshot.data == true;

        // Use an Image widget so we can provide an errorBuilder for network images
        final Widget backgroundImage = useAsset
            ? Image.asset('assets/images/background.jpg', fit: BoxFit.cover)
            : Image.network(
                'https://images.unsplash.com/photo-1551434678-e076c223a692?auto=format&fit=crop&w=1350&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
              );

        return Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
                child: backgroundImage,
              ),
            ),
            child,
          ],
        );
      },
    );
  }
}
