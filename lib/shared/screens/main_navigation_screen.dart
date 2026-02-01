import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/expenses/screens/expenses_dashboard_screen.dart';
import '../../features/budgets/screens/budget_dashboard_screen.dart';
import '../../features/savings_goals/screens/savings_dashboard_screen.dart';
import '../../features/reports/screens/insights_dashboard_screen.dart';
import '../../features/accounts/screens/accounts_dashboard_screen.dart';
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

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  String _selectedRoute = 'dashboard';
  bool _isSidebarOpen = true;

  final List<Map<String, dynamic>> _dashboardItems = [
    {'label': 'Home', 'icon': Icons.home_outlined, 'route': 'dashboard', 'category': 'Overview'},
    {'label': 'Expenses', 'icon': Icons.receipt_outlined, 'route': 'expenses', 'category': 'Overview'},
    {'label': 'Budgets', 'icon': Icons.show_chart_outlined, 'route': 'budgets-dash', 'category': 'Overview'},
    {'label': 'Savings Goals', 'icon': Icons.flag_outlined, 'route': 'savings-dash', 'category': 'Overview'},
    {'label': 'Insights', 'icon': Icons.analytics_outlined, 'route': 'insights', 'category': 'Overview'},
    {'label': 'Accounts', 'icon': Icons.account_balance_wallet_outlined, 'route': 'accounts-dash', 'category': 'Management'},
    {'label': 'Settings', 'icon': Icons.settings_outlined, 'route': 'settings-dash', 'category': 'Management'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          if (!isMobile || _isSidebarOpen)
            NavigationRail(
              selectedIndex: _dashboardItems.indexWhere((item) => item['route'] == _selectedRoute),
              extended: !isMobile,
              destinations: _dashboardItems
                  .map((item) => NavigationRailDestination(
                    icon: Icon(item['icon']),
                    label: Text(item['label']),
                  ))
                  .toList(),
              onDestinationSelected: (index) {
                setState(() => _selectedRoute = _dashboardItems[index]['route']);
                context.go('/home/${_dashboardItems[index]['route']}');
              },
            ),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Header with branding and actions
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    border: Border(
                      bottom: BorderSide(color: AppTheme.borderColor, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isMobile)
                            IconButton(
                              icon: Icon(_isSidebarOpen ? Icons.menu_open : Icons.menu),
                              onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _getPageTitle(_selectedRoute),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeaderAction(Icons.refresh_outlined, 'Refresh', () {}),
                          const SizedBox(width: 16),
                          _buildHeaderAction(Icons.download_outlined, 'Export', () {}),
                          const SizedBox(width: 16),
                          _buildHeaderAction(Icons.more_vert, 'More', () {}),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedRoute) {
      case 'dashboard':
        return const DashboardScreen();
      case 'expenses':
        return const ExpensesDashboardScreen();
      case 'budgets-dash':
        return const BudgetDashboardScreen();
      case 'savings-dash':
        return const SavingsDashboardScreen();
      case 'insights':
        return const InsightsDashboardScreen();
      case 'accounts-dash':
        return const AccountsDashboardScreen();
      case 'settings-dash':
        return const SettingsDashboardScreen();
      case 'accounts':
        return const AccountsScreen();
      case 'accounts/add':
        return const AddAccountScreen();
      case 'transactions':
        return const TransactionsScreen();
      case 'transactions/add':
        return const AddTransactionScreen();
      case 'budgets':
        return const BudgetsScreen();
      case 'budgets/add':
        return const AddBudgetScreen();
      case 'savings-goals':
        return const SavingsGoalsScreen();
      case 'savings-goals/add':
        return const AddSavingsGoalScreen();
      case 'reports':
        return const ReportsScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  Widget _buildHeaderAction(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: AppTheme.primaryColor),
        onPressed: onTap,
      ),
    );
  }

  String _getPageTitle(String route) {
    final item = _dashboardItems.firstWhere(
      (item) => item['route'] == route,
      orElse: () => {'label': 'Dashboard'},
    );
    return item['label'] ?? 'Dashboard';
  }
}
