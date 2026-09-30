import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  // Replace these API keys with your actual RevenueCat API keys
  static const _androidApiKey = 'goog_your_android_api_key_here';
  static const _iosApiKey = 'appl_your_ios_api_key_here';

  // Default entitlement identifier configured in RevenueCat Dashboard
  static const String defaultEntitlementId = 'pro';

  /// Initializes RevenueCat SDK. Call this in main() before runApp().
  static Future<void> init() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_androidApiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_iosApiKey);
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
    }
  }

  /// Associates the app session with a specific user ID upon login/signup.
  static Future<void> logIn(String appUserId) async {
    try {
      await Purchases.logIn(appUserId);
    } catch (e) {
      debugPrint('RevenueCat logIn error: $e');
    }
  }

  /// Resets user identity in RevenueCat upon logout.
  static Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      debugPrint('RevenueCat logOut error: $e');
    }
  }

  /// Checks if the user currently has an active entitlement/subscription.
  static Future<bool> hasActiveSubscription({
    String entitlementId = defaultEntitlementId,
  }) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.all[entitlementId];
      return entitlement?.isActive ?? false;
    } catch (e) {
      debugPrint('Error checking active subscription: $e');
      return false;
    }
  }

  /// Fetches available offerings/products from RevenueCat.
  static Future<Offerings?> fetchOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
      return null;
    }
  }

  /// Triggers purchase flow for a RevenueCat Package.
  static Future<bool> purchasePackage(
    Package package, {
    String entitlementId = defaultEntitlementId,
  }) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      final entitlement = customerInfo.entitlements.all[entitlementId];
      return entitlement?.isActive ?? false;
    } catch (e) {
      debugPrint('Purchase failed or canceled: $e');
      return false;
    }
  }

  /// Restores prior purchases.
  static Future<bool> restorePurchases({
    String entitlementId = defaultEntitlementId,
  }) async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      final entitlement = customerInfo.entitlements.all[entitlementId];
      return entitlement?.isActive ?? false;
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      return false;
    }
  }
}
