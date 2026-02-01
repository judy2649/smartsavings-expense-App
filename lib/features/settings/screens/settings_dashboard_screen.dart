import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SettingsDashboardScreen extends StatefulWidget {
  const SettingsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SettingsDashboardScreen> createState() =>
      _SettingsDashboardScreenState();
}

class _SettingsDashboardScreenState extends State<SettingsDashboardScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool biometricEnabled = false;
  String selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        backgroundColor: AppTheme.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            _buildProfileSection(),
            const SizedBox(height: 8),

            // Preferences Section
            _buildSectionTitle('Preferences'),
            _buildToggleSetting(
              'Notifications',
              'Receive spending alerts and budget updates',
              notificationsEnabled,
              (value) {
                setState(() => notificationsEnabled = value);
              },
            ),
            _buildToggleSetting(
              'Dark Mode',
              'Use dark theme for easier viewing',
              darkModeEnabled,
              (value) {
                setState(() => darkModeEnabled = value);
              },
            ),
            _buildSelectSetting(
              'Currency',
              selectedCurrency,
            ),
            const SizedBox(height: 8),

            // Security Section
            _buildSectionTitle('Security'),
            _buildToggleSetting(
              'Biometric Login',
              'Use fingerprint or face recognition',
              biometricEnabled,
              (value) {
                setState(() => biometricEnabled = value);
              },
            ),
            _buildSimpleSetting(
              'Change Password',
              'Update your account password',
              Icons.arrow_forward,
            ),
            _buildSimpleSetting(
              'Two-Factor Authentication',
              'Add extra security to your account',
              Icons.arrow_forward,
            ),
            const SizedBox(height: 8),

            // Account Section
            _buildSectionTitle('Account'),
            _buildSimpleSetting(
              'Edit Profile',
              'Update your personal information',
              Icons.arrow_forward,
            ),
            _buildSimpleSetting(
              'Connected Accounts',
              'Manage linked accounts and institutions',
              Icons.arrow_forward,
            ),
            _buildSimpleSetting(
              'Export Data',
              'Download your financial data',
              Icons.arrow_forward,
            ),
            const SizedBox(height: 8),

            // Support Section
            _buildSectionTitle('Support'),
            _buildSimpleSetting(
              'Help Center',
              'Browse FAQs and documentation',
              Icons.arrow_forward,
            ),
            _buildSimpleSetting(
              'Contact Support',
              'Get help from our support team',
              Icons.arrow_forward,
            ),
            _buildSimpleSetting(
              'About',
              'Version 1.0.0',
              null,
            ),
            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'john@example.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.darkColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildSelectSetting(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.darkColor,
        ),
      ),
      subtitle: const Text(
        'Choose your preferred currency',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: ['USD', 'EUR', 'GBP', 'JPY'].map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(currency),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() => selectedCurrency = newValue);
          }
        },
        underline: Container(),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildSimpleSetting(String title, String subtitle, IconData? icon) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.darkColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: icon != null ? Icon(icon, color: Colors.grey.shade400) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title tapped')),
        );
      },
    );
  }
}
