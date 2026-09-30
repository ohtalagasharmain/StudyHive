import 'package:flutter/material.dart';
import '../pages/main_shell.dart';
import '../pages/paywall_page.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'revenuecat_service.dart';

class SubscriptionRouter {
  /// Checks user's RevenueCat entitlement status and navigates accordingly.
  /// - Has active subscription -> Navigates to [MainShell]
  /// - No active subscription -> Navigates to [PaywallPage]
  static Future<void> navigateBasedOnSubscription(BuildContext context) async {
    // Show loading spinner dialog while checking subscription status
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.honeyDark),
      ),
    );

    final bool hasActiveSub = await RevenueCatService.hasActiveSubscription();

    if (!context.mounted) return;

    // Dismiss loading spinner dialog
    Navigator.of(context, rootNavigator: true).pop();

    if (hasActiveSub) {
      // Navigate to Main App Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } else {
      // Navigate to Paywall Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PaywallPage()),
        (route) => false,
      );
    }
  }
}

/// Wrapper Widget that performs the subscription check on app load/mount.
class SubscriptionGateWidget extends StatelessWidget {
  const SubscriptionGateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: RevenueCatService.hasActiveSubscription(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const HoneycombBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.honeyDark),
              ),
            ),
          );
        }

        final bool hasSubscription = snapshot.data ?? false;

        if (hasSubscription) {
          return const MainShell();
        } else {
          return const PaywallPage();
        }
      },
    );
  }
}
