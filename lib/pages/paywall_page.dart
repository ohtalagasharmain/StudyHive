import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/revenuecat_service.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'main_shell.dart';

class PaywallPage extends StatefulWidget {
  final bool isModal;

  const PaywallPage({super.key, this.isModal = false});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  bool _isLoadingOfferings = true;
  bool _isProcessingPurchase = false;
  Offerings? _offerings;
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() => _isLoadingOfferings = true);
    final offerings = await RevenueCatService.fetchOfferings();
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _isLoadingOfferings = false;
        if (offerings?.current != null &&
            offerings!.current!.availablePackages.isNotEmpty) {
          _selectedPackage = offerings.current!.availablePackages.first;
        }
      });
    }
  }

  void _handleSubscribe() {
    setState(() => _isProcessingPurchase = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isProcessingPurchase = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to StudyHive Premium! 🎉'),
          backgroundColor: AppColors.successGreen,
          duration: Duration(seconds: 2),
        ),
      );

      // Redirect to Premium Account (Main App Screen)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    });
  }

  void _handleStayBasic() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Continuing with Basic Account'),
        duration: Duration(seconds: 2),
      ),
    );

    // Redirect to Basic Account (Main App Screen)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  Future<void> _handleRestorePurchases() async {
    setState(() => _isProcessingPurchase = true);

    final isRestored = await RevenueCatService.restorePurchases();

    if (!mounted) return;
    setState(() => _isProcessingPurchase = false);

    if (isRestored) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchases restored successfully!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active subscriptions found to restore.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availablePackages = _offerings?.current?.availablePackages ?? [];

    return HoneycombBackground(
      showHoneycomb: false, // Same background as HomePage for clear readability
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0),
              child: Material(
                color: AppColors.honeyYellow.withValues(alpha: 0.3),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.honeyDark, size: 24),
                  tooltip: 'Stay with Basic Account',
                  onPressed: _handleStayBasic,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.honeyYellow.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium,
                            size: 64,
                            color: AppColors.honeyDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Unlock StudyHive Pro',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.honeyDark,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Get full access to all AI tools, unlimited study groups, and adaptive quizzes.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureTile(
                          Icons.auto_awesome,
                          'Unlimited AI Summaries',
                          'Generate summaries and flashcards instantly',
                        ),
                        _buildFeatureTile(
                          Icons.groups,
                          'Unlimited Study Hives',
                          'Create and join as many study groups as you want',
                        ),
                        _buildFeatureTile(
                          Icons.quiz,
                          'Adaptive Quiz Engine',
                          'Personalized practice exams tailored to your goals',
                        ),
                        const SizedBox(height: 24),
                        if (_isLoadingOfferings)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(color: AppColors.honeyDark),
                            ),
                          )
                        else if (availablePackages.isEmpty)
                          _buildFallbackPackageCard()
                        else
                          Column(
                            children: availablePackages.map((pkg) {
                              final isSelected = _selectedPackage?.identifier == pkg.identifier;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedPackage = pkg),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.honeyYellow.withValues(alpha: 0.3)
                                        : AppColors.cardWhite,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.honeyDark
                                          : AppColors.honeyYellow,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: AppColors.honeyDark,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pkg.storeProduct.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              pkg.storeProduct.description,
                                              style: const TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        pkg.storeProduct.priceString,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppColors.honeyDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    PrimaryButton(
                      text: 'Subscribe Now',
                      isLoading: _isProcessingPurchase,
                      icon: Icons.star,
                      onPressed: _handleSubscribe,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isProcessingPurchase ? null : _handleRestorePurchases,
                      child: const Text('Restore Purchases'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.honeyYellow.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.honeyDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackPackageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.honeyDark, width: 2),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pro Monthly Access',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Full access to all StudyHive features',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          Text(
            '\$4.99/mo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.honeyDark,
            ),
          ),
        ],
      ),
    );
  }
}
