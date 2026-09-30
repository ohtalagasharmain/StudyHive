import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _selectedPlan = 1; // 0 = Monthly, 1 = Yearly (Best value)

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.honeyDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'StudyHive Pro',
            style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.purpleAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium, size: 48, color: AppColors.purpleAccent),
              ),
              const SizedBox(height: 16),
              Text(
                'Unlock Unlimited Learning',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Get full access to AI Study Packs, unlimited adaptive quizzes, and priority group features.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Benefits List
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _benefitRow('Unlimited AI Study Pack Generators'),
                    _benefitRow('Unlimited Adaptive Quiz Practice'),
                    _benefitRow('Detailed Subject Analytics & Insights'),
                    _benefitRow('Priority Upload Storage & High-Res PDF/Image Views'),
                    _benefitRow('Ad-Free Learning Experience'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Plans Selector
              Row(
                children: [
                  Expanded(
                    child: _buildPlanTile(
                      index: 0,
                      title: 'Monthly',
                      price: '\$4.99 / mo',
                      subtitle: 'Billed monthly',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPlanTile(
                      index: 1,
                      title: 'Yearly',
                      price: '\$2.99 / mo',
                      subtitle: '\$35.88 / yr (Save 40%)',
                      isBestValue: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              PrimaryButton(
                text: _selectedPlan == 1 ? 'Subscribe Yearly (\$35.88/yr)' : 'Subscribe Monthly (\$4.99/mo)',
                icon: Icons.workspace_premium,
                backgroundColor: AppColors.purpleAccent,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('StudyHive Pro subscription activated! Welcome aboard!')),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Restore Purchases', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.successGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTile({
    required int index,
    required String title,
    required String price,
    required String subtitle,
    bool isBestValue = false,
  }) {
    final selected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.purpleAccent.withValues(alpha: 0.1) : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.purpleAccent : AppColors.honeyYellow.withValues(alpha: 0.5),
            width: selected ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          children: [
            if (isBestValue)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BEST VALUE',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.purpleAccent)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
