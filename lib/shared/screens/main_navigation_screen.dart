import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../features/ui/ui_screens.dart' as ui;
// legacy dashboard screens replaced by UI prototypes
import '../../features/reports/screens/insights_dashboard_screen.dart';
// accounts dashboard replaced by UI accounts screen
import '../../features/settings/screens/settings_dashboard_screen.dart';
import '../../features/accounts/screens/accounts_screen.dart';
import '../../features/accounts/screens/add_account_screen.dart';
import '../../features/transactions/screens/transactions_screen.dart';
import '../../features/transactions/screens/add_transaction_screen.dart';
import '../../features/accounts/screens/connect_accounts_screen.dart';
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
    // Prototype UI screens
    {'label': 'UI Dashboard', 'icon': Icons.dashboard_outlined, 'route': 'ui-dashboard', 'category': 'Prototype'},
    {'label': 'UI Transactions', 'icon': Icons.list_alt_outlined, 'route': 'ui-transactions', 'category': 'Prototype'},
    {'label': 'UI Budgets', 'icon': Icons.pie_chart_outline, 'route': 'ui-budgets', 'category': 'Prototype'},
    {'label': 'UI Goals', 'icon': Icons.flag_outlined, 'route': 'ui-goals', 'category': 'Prototype'},
    {'label': 'UI Accounts', 'icon': Icons.account_balance_wallet_outlined, 'route': 'ui-accounts', 'category': 'Prototype'},
    {'label': 'Wireframes', 'icon': Icons.image_outlined, 'route': 'wireframes', 'category': 'Prototype'},
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
          
          // Main Content Area with business-photo background
          Expanded(
            child: Stack(
              children: [
                // Business/people background image
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1600&q=80',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.25),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.transparent),
                  ),
                ),
                // Foreground content with header and pages
                Column(
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
                              // Menu: open dashboards list
                              Tooltip(
                                message: 'Dashboards',
                                child: IconButton(
                                  icon: const Icon(Icons.menu, color: AppTheme.primaryColor),
                                  onPressed: () => _showDashboardsMenu(context),
                                ),
                              ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDashboardsMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _dashboardItems.map((item) {
              return ListTile(
                leading: Icon(item['icon'], color: AppTheme.primaryColor),
                title: Text(item['label']),
                subtitle: item['category'] != null ? Text(item['category']) : null,
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() => _selectedRoute = item['route']);
                  context.go('/home/${item['route']}');
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_selectedRoute) {
      case 'dashboard':
        return const ui.DashboardScreen();
      case 'expenses':
        return const ui.TransactionsScreen();
      case 'budgets-dash':
        return const ui.BudgetsScreen();
      case 'savings-dash':
        return const ui.GoalsScreen();
      case 'insights':
        return const InsightsDashboardScreen();
      case 'accounts-dash':
        return const ui.AccountsScreen();
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
      case 'connect-accounts':
        return const ConnectAccountsScreen();
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
      // Prototype UI screens
      case 'ui-dashboard':
        return const ui.DashboardScreen();
      case 'ui-transactions':
        return const ui.TransactionsScreen();
      case 'ui-budgets':
        return const ui.BudgetsScreen();
      case 'ui-goals':
        return const ui.GoalsScreen();
      case 'ui-accounts':
        return const ui.AccountsScreen();
      case 'wireframes':
        return const ui.WireframePreviewScreen();
      default:
        return const ui.DashboardScreen();
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
