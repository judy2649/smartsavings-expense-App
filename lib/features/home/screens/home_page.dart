import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image (people & finance)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=1600&q=80',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.35),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.transparent),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Top actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.push('/signup'),
                            child: const Text('Sign up'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => context.push('/login'),
                            child: const Text('Log in'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Main welcome
                      Expanded(
                        child: Row(
                          children: [
                            // Left column: text
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Welcome to Smart Savings',
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Manage your finances easily with our tool.',
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      color: AppTheme.secondaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    'Smart Savings helps you track spending, manage multiple wallets, set budgets and reach your savings goals — all in one beautiful, secure app.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 24),

                                  // Three reasons
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: const [
                                      _ReasonCard(title: 'Secure & Private', subtitle: 'Your data is protected with modern auth and encryption.'),
                                      _ReasonCard(title: 'All-in-one Dashboard', subtitle: 'Overview of accounts, budgets, and reports.'),
                                      _ReasonCard(title: 'Multi-wallet Support', subtitle: 'Manage multiple accounts and transfer between them.'),
                                    ],
                                  ),

                                  const SizedBox(height: 28),

                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => context.push('/signup'),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                          child: Text('Get Started'),
                                        ),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                                      ),
                                      const SizedBox(width: 12),
                                      TextButton(
                                        onPressed: () => context.push('/login'),
                                        child: const Text('Log in to get started!'),
                                        style: TextButton.styleFrom(foregroundColor: AppTheme.secondaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            if (!isMobile) const SizedBox(width: 32),

                            // Right column: features list
                            if (!isMobile)
                              Expanded(
                                flex: 4,
                                child: Card(
                                  color: const Color(0xFF1F4788).withOpacity(0.9),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Features of this app', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 12),
                                        const _FeatureItem(text: 'User Authentication and Security'),
                                        const _FeatureItem(text: 'Dashboard Overview'),
                                        const _FeatureItem(text: 'Multi-Wallet Management'),
                                        const _FeatureItem(text: 'Transaction Management'),
                                        const _FeatureItem(text: 'Balance Adjustment Management'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ReasonCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F4788).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.successColor, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white))),
        ],
      ),
    );
  }
}
