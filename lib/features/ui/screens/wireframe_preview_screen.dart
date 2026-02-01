import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WireframePreviewScreen extends StatelessWidget {
  static const String routeName = '/wireframes';
  const WireframePreviewScreen({Key? key}) : super(key: key);

  final List<String> _files = const [
    'assets/wireframes/dashboard_wireframe',
    'assets/wireframes/transactions_wireframe',
    'assets/wireframes/add_transaction_wireframe',
    'assets/wireframes/budgets_wireframe',
    'assets/wireframes/goals_wireframe',
    'assets/wireframes/accounts_wireframe',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wireframe Preview')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _files.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final path = _files[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(path.split('/').last.replaceAll('_', ' ').replaceAll('.svg', ''), style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 400,
                      child: Builder(builder: (context) {
                        final png = '${path}.png';
                        final svg = '${path}.svg';
                        // Prefer PNG if available (faster on some platforms), fallback to SVG
                        return Image.asset(png, fit: BoxFit.contain, errorBuilder: (ctx, err, st) {
                          return SvgPicture.asset(svg, fit: BoxFit.contain, placeholderBuilder: (context) => const Center(child: CircularProgressIndicator()));
                        });
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
