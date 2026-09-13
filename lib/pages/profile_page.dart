import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'help_assistant_page.dart';
import 'study_feature_page.dart';
import 'edit_profile_page.dart';

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
  final String _name = 'Study Hive';
  final String _username = 'studyhive';
  final String _bio = 'Focused on learning, one session at a time.';
  final String _grade = 'Grade 11';
  final String _subjects = 'Physics, Mathematics';

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              SizedBox(height: 18),
              _buildProCard(context),
              SizedBox(height: 24),
              _sectionTitle('Honeycomb'),
              SizedBox(height: 10),
              _buildHoneycombCard(),
              SizedBox(height: 24),
              _sectionTitle('Profile Menu'),
              SizedBox(height: 10),
              _buildMenuCard(),
              SizedBox(height: 24),
              _sectionTitle('Account'),
              SizedBox(height: 10),
              _buildAccountCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return _card(
      color: AppColors.cardWhite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onEditAvatar ?? () => _showAvatarSheet(context),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.honeyYellow.withValues(
                    alpha: 0.35,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 42,
                    color: AppColors.honeyDark,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.honeyDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.edit, size: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_name, style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 2),
                Text(
                  '@$_username',
                  style: TextStyle(
                    color: AppColors.honeyDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  _bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '$_grade • $_subjects',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 11),
                ),
                SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _openEditProfilePage(context),
                  icon: Icon(Icons.edit_outlined, size: 16),
                  label: Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.honeyDark,
                    side: BorderSide(color: AppColors.honeyYellow),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: TextStyle(
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
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'StudyHive Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 3),
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
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
              SizedBox(width: 12),
              Expanded(
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
          SizedBox(height: 10),
          Text(
            'Unlock deeper insights, unlimited study plans, and premium learning tools.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: ['Unlimited insights', 'Priority tools', 'No ads']
                .map(
                  (benefit) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.successGreen,
                        size: 15,
                      ),
                      SizedBox(width: 4),
                      Text(
                        benefit,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onPressUpgrade ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purpleAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.honeyYellow.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hexagon, color: AppColors.honeyDark),
              ),
              SizedBox(width: 10),
              Expanded(
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
                '5 Day Streak',
                style: TextStyle(
                  color: AppColors.accentOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level 2', style: _menuText()),
              Text(
                '12/20 Honeycombs to next level',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 9,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.honeyDark),
            ),
          ),
          SizedBox(height: 16),
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
              SnackBar(content: Text('Ad reward is ready in the mock UI.')),
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
              style: TextStyle(
                color: AppColors.successGreen,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            )
          : TextButton(onPressed: onTap, child: Text(trailing)),
    );
  }

  Widget _buildMenuCard() {
    final items = [
      ('My Profile', Icons.person_outline, null),
      ('Study Insights', Icons.analytics_outlined, null),
      ('Saved Resources', Icons.bookmark_border, '8'),
      ('Study Groups', Icons.groups_outlined, '4'),
      ('Achievements', Icons.emoji_events_outlined, '12'),
      ('App Preferences', Icons.settings_outlined, null),
    ];
    return _card(
      padding: EdgeInsets.symmetric(vertical: 8),
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
            style: TextStyle(
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.honeyYellow.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: AppColors.honeyDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14),
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
    final feature = switch (topic) {
      'Study Insights' => StudyFeature.insights,
      'Saved Resources' => StudyFeature.resources,
      'Study Groups' => StudyFeature.groups,
      'Achievements' => StudyFeature.achievements,
      'App Preferences' => StudyFeature.preferences,
      'Manage Subscription' => StudyFeature.subscription,
      _ => null,
    };
    if (feature != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StudyFeaturePage(feature: feature)),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HelpAssistantPage(initialQuestion: topic),
      ),
    );
  }

  void _openEditProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilePage()),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return _card(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.purpleAccent,
            ),
            title: Text('Manage Subscription', style: _menuText()),
            trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => _openGuide('Manage Subscription'),
          ),
          Divider(
            height: 1,
            indent: 58,
            endIndent: 14,
            color: AppColors.honeyCombLine.withValues(alpha: 0.45),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.errorRed),
            title: Text(
              'Sign Out',
              style: _menuText(color: AppColors.errorRed),
            ),
            trailing: Icon(Icons.chevron_right, color: AppColors.errorRed),
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
    style: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _proIcon() => Container(
    padding: EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: AppColors.honeyYellow.withValues(alpha: 0.3),
      shape: BoxShape.circle,
    ),
    child: Icon(Icons.workspace_premium, color: AppColors.honeyDark, size: 22),
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
    offset: Offset(0, 5),
  );

  void _showAvatarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update profile photo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 14),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.honeyDark,
                ),
                title: Text('Choose from gallery'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.honeyDark,
                ),
                title: Text('Take a photo'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Sign out?'),
        content: Text(
          'Your local profile view will remain unchanged, but this mock action will end the current session.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
