import 'package:flutter/material.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';
import 'preferences_page.dart';
import 'hives_page.dart';
import 'saved_resources_page.dart';
import 'hive_overview_page.dart';
import 'study_insights_page.dart';
import 'achievements_page.dart';
import 'subscription_page.dart';
import '../services/app_state.dart';
import '../services/localization_service.dart';

class ProfilePage extends StatefulWidget {
  final bool isProSubscriber;
  final VoidCallback? onEditAvatar;
  final VoidCallback? onPressUpgrade;
  final ValueChanged<String>? onPressStat;

  const ProfilePage({
    super.key,
    this.isProSubscriber = false,
    this.onEditAvatar,
    this.onPressUpgrade,
    this.onPressStat,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final user = AppState().user;
        return HoneycombBackground(
          showGradient: false,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(context, user),
                  const SizedBox(height: 18),
                  _buildProCard(context),
                  const SizedBox(height: 24),
                  _sectionTitle('Honeycomb'),
                  const SizedBox(height: 10),
                  _buildHoneycombCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(L10n.of(context, 'settings')),
                  const SizedBox(height: 10),
                  _buildMenuCard(),
                  const SizedBox(height: 24),
                  _sectionTitle('Account'),
                  const SizedBox(height: 10),
                  _buildAccountCard(context),
                  const SizedBox(height: 24),
                  _sectionTitle(L10n.of(context, 'myStudyGroups')),
                  const SizedBox(height: 10),
                  _buildJoinedGroupsList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserData user) {
    return _card(
      color: AppColors.cardWhite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onEditAvatar ?? () => _openEditProfilePage(context),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.honeyYellow.withValues(alpha: 0.35),
                  backgroundImage: (user.profilePicturePath != null && File(user.profilePicturePath!).existsSync()) 
                      ? FileImage(File(user.profilePicturePath!)) 
                      : null,
                  child: (user.profilePicturePath == null || !File(user.profilePicturePath!).existsSync()) 
                      ? const Icon(Icons.person, size: 42, color: AppColors.honeyDark)
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.honeyDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, size: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: const TextStyle(
                    color: AppColors.honeyDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  user.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${user.grade} • ${user.subjects}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _openEditProfilePage(context),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.honeyDark,
                    side: const BorderSide(color: AppColors.honeyYellow),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProCard(BuildContext context) {
    if (widget.isProSubscriber) {
      return _card(
        color: AppColors.purpleAccent,
        child: Row(
          children: [
            _proIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'StudyHive Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Active subscriber • All tools unlocked',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _openGuide('Manage Subscription'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.purpleAccent,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Manage Subscription',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return _card(
      color: AppColors.purpleAccent.withValues(alpha: 0.1),
      borderColor: AppColors.purpleAccent.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _proIcon(),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Upgrade to StudyHive Pro',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Unlock deeper insights, unlimited study plans, and premium learning tools.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: ['Unlimited insights', 'Priority tools', 'No ads']
                .map(
                  (benefit) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.successGreen,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        benefit,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onPressUpgrade ?? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purpleAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Upgrade Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoneycombCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.honeyYellow.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hexagon, color: AppColors.honeyDark),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '12 Honeycombs',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${AppState().studyStreak} Day Streak',
                style: const TextStyle(
                  color: AppColors.accentOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level 2', style: _menuText()),
              const Text(
                '12/20 Honeycombs to next level',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: AppState().dailyProgress,
              minHeight: 9,
              backgroundColor: AppColors.progressBg,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.honeyDark),
            ),
          ),
          const SizedBox(height: 16),
          _honeycombEarningRow(
            icon: Icons.login,
            title: 'Daily Login',
            detail: 'Opened today',
            trailing: '+1 Honeycomb claimed',
          ),
          _honeycombEarningRow(
            icon: Icons.menu_book_outlined,
            title: 'Study Activities',
            detail: '2 of 3 tasks completed today',
            trailing: '+2 available',
          ),
          _honeycombEarningRow(
            icon: Icons.ondemand_video_outlined,
            title: 'Watch Ads',
            detail: 'Support your next level',
            trailing: 'Watch Ad (+1)',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ad reward is ready in the mock UI.')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _honeycombEarningRow({
    required IconData icon,
    required String title,
    required String detail,
    required String trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.honeyDark),
      title: Text(title, style: _menuText()),
      subtitle: Text(detail),
      trailing: onTap == null
          ? Text(
              trailing,
              style: const TextStyle(
                color: AppColors.successGreen,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            )
          : TextButton(onPressed: onTap, child: Text(trailing)),
    );
  }

  Widget _buildMenuCard() {
    final appState = AppState();
    final items = [
      ('My Profile', Icons.person_outline, null),
      ('Study Insights', Icons.analytics_outlined, null),
      (L10n.of(context, 'savedResources'), Icons.bookmark_border, 
        appState.savedResources.isEmpty ? null : '${appState.savedResources.length}'),
      (L10n.of(context, 'studyGroups'), Icons.groups_outlined, 
        appState.hives.isEmpty ? null : '${appState.hives.length}'),
      ('Achievements', Icons.emoji_events_outlined, '12'),
      (L10n.of(context, 'settings'), Icons.settings_outlined, null),
    ];
    return _card(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (entry) => _menuItem(
                entry.value.$1,
                entry.value.$2,
                entry.value.$3,
                entry.key == items.length - 1,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _menuItem(String label, IconData icon, String? badge, bool isLast) {
    return Column(
      children: [
        ListTile(
          onTap: () => _openGuide(label),
          leading: Icon(icon, color: AppColors.honeyDark),
          title: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.honeyYellow.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: AppColors.honeyDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 58,
            endIndent: 14,
            color: AppColors.honeyCombLine.withValues(alpha: 0.45),
          ),
      ],
    );
  }

  void _openGuide(String topic) {
    if (topic == 'My Profile') {
      _openEditProfilePage(context);
      return;
    }
    if (topic == 'Study Insights') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StudyInsightsPage()),
      );
      return;
    }
    if (topic == 'Achievements') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AchievementsPage()),
      );
      return;
    }
    if (topic == 'Manage Subscription') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionPage()),
      );
      return;
    }
    if (topic == L10n.of(context, 'studyGroups')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HivesPage()),
      );
      return;
    }
    if (topic == L10n.of(context, 'savedResources')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SavedResourcesPage()),
      );
      return;
    }
    if (topic == L10n.of(context, 'settings')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PreferencesPage()),
      );
      return;
    }
  }

  void _openEditProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilePage()),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return _card(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.purpleAccent,
            ),
            title: Text('Manage Subscription', style: _menuText()),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => _openGuide('Manage Subscription'),
          ),
          Divider(
            height: 1,
            indent: 58,
            endIndent: 14,
            color: AppColors.honeyCombLine.withValues(alpha: 0.45),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.errorRed),
            title: Text(
              L10n.of(context, 'signOut'),
              style: _menuText(color: AppColors.errorRed),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.errorRed),
            onTap: () => _showSignOutDialog(context),
          ),
        ],
      ),
    );
  }

  TextStyle _menuText({Color? color}) => TextStyle(
    color: color ?? AppColors.textPrimary,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _proIcon() => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: AppColors.honeyYellow.withValues(alpha: 0.3),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.workspace_premium, color: AppColors.honeyDark, size: 22),
  );

  Widget _card({
    required Widget child,
    Color? color,
    Color? borderColor,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: borderColor == null ? null : Border.all(color: borderColor),
        boxShadow: [_shadow()],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }

  BoxShadow _shadow() => BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 14,
    offset: const Offset(0, 5),
  );

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${L10n.of(context, 'signOut')}?'),
        content: const Text(
          'Your local profile view will remain unchanged, but this mock action will end the current session.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              AppState().signOut();
              Navigator.pop(dialogContext);
              // Small delay to ensure state updates
              await Future.delayed(const Duration(milliseconds: 100));
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: Text(L10n.of(context, 'signOut')),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedGroupsList() {
    final user = AppState().user;
    final joinedHives = AppState().hives.where((h) => 
      h.membersList.contains(user.name) || 
      h.membersList.contains('You') || 
      h.owned).toList();

    if (joinedHives.isEmpty) {
      return _card(
        child: const Center(
          child: Text('You haven\'t joined any study groups yet.', 
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
      );
    }

    return Column(
      children: joinedHives.map((hive) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _card(
          padding: EdgeInsets.zero,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HiveOverviewPage(
                    hiveId: hive.id,
                    hiveName: hive.name,
                    hiveSubject: hive.subject,
                    hiveMembers: hive.members,
                    hiveIcon: hive.icon,
                  ),
                ),
              );
            },
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hive.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(hive.icon, style: const TextStyle(fontSize: 22))),
            ),
            title: Text(hive.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text(hive.subject, style: const TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ),
        ),
      )).toList(),
    );
  }
}
