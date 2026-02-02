import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/email_verification_screen.dart';
import '../../features/home/screens/home_page.dart';
// Use the new UI prototype screens as the primary dashboards
import '../../features/ui/ui_screens.dart' as ui_primary;
import '../../features/ui/screens/dashboard_screen_v2.dart' as ui_dashboard_v2;
// legacy dashboard imports removed — using UI screens instead
import '../../features/reports/screens/insights_dashboard_screen.dart';
// accounts dashboard replaced by UI accounts screen
import '../../features/settings/screens/settings_dashboard_screen.dart';
import '../../features/accounts/screens/accounts_screen.dart';
import '../../features/accounts/screens/add_account_screen.dart';
import '../../features/transactions/screens/transactions_screen.dart';
import '../../features/transactions/screens/add_transaction_screen.dart';
import '../../features/budgets/screens/budgets_screen.dart';
import '../../features/budgets/screens/add_budget_screen.dart';
import '../../features/savings_goals/screens/savings_goals_screen.dart';
import '../../features/savings_goals/screens/add_savings_goal_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../shared/screens/main_navigation_screen.dart';
import '../../features/ui/ui_screens.dart' as ui;
import '../../features/ui/screens/wireframe_preview_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    // Start the app on the public Home page with welcome content
    initialLocation: '/',
    routes: [
      // Public Home / landing page
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return EmailVerificationScreen(email: email);
        },
      ),
      
      // Main App Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
        routes: [
          // Replace legacy dashboard with the new UI dashboard V2
          GoRoute(
            path: 'dashboard',
            builder: (context, state) => const ui_dashboard_v2.DashboardScreenV2(),
          ),
          // Map expenses to the UI transactions screen for a consistent UX
          GoRoute(
            path: 'expenses',
            builder: (context, state) => const ui_primary.TransactionsScreen(),
          ),
          GoRoute(
            path: 'budgets-dash',
            builder: (context, state) => const ui_primary.BudgetsScreen(),
          ),
          GoRoute(
            path: 'savings-dash',
            builder: (context, state) => const ui_primary.GoalsScreen(),
          ),
          GoRoute(
            path: 'insights',
            builder: (context, state) => const InsightsDashboardScreen(),
          ),
          GoRoute(
            path: 'accounts-dash',
            builder: (context, state) => const ui_primary.AccountsScreen(),
          ),
          GoRoute(
            path: 'settings-dash',
            builder: (context, state) => const SettingsDashboardScreen(),
          ),
          GoRoute(
            path: 'accounts',
            builder: (context, state) => const AccountsScreen(),
          ),
          GoRoute(
            path: 'accounts/add',
            builder: (context, state) => const AddAccountScreen(),
          ),
          GoRoute(
            path: 'transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          GoRoute(
            path: 'transactions/add',
            builder: (context, state) => const AddTransactionScreen(),
          ),
          GoRoute(
            path: 'budgets',
            builder: (context, state) => const BudgetsScreen(),
          ),
          GoRoute(
            path: 'budgets/add',
            builder: (context, state) => const AddBudgetScreen(),
          ),
          GoRoute(
            path: 'savings-goals',
            builder: (context, state) => const SavingsGoalsScreen(),
          ),
          GoRoute(
            path: 'savings-goals/add',
            builder: (context, state) => const AddSavingsGoalScreen(),
          ),
          GoRoute(
            path: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          // Prototype UI scaffold routes
          GoRoute(
            path: 'ui-dashboard',
            builder: (context, state) => const ui.DashboardScreen(),
          ),
          GoRoute(
            path: 'ui-transactions',
            builder: (context, state) => const ui.TransactionsScreen(),
          ),
          GoRoute(
            path: 'ui-budgets',
            builder: (context, state) => const ui.BudgetsScreen(),
          ),
          GoRoute(
            path: 'ui-goals',
            builder: (context, state) => const ui.GoalsScreen(),
          ),
          GoRoute(
            path: 'ui-accounts',
            builder: (context, state) => const ui.AccountsScreen(),
          ),
          GoRoute(
            path: 'wireframes',
            builder: (context, state) => const WireframePreviewScreen(),
          ),
        ],
      ),
    ],
  );
}
