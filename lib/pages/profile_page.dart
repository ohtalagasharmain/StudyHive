import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';

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
  String _name = 'Study Hive';
  String _username = 'studyhive';
  String _bio = 'Focused on learning, one session at a time.';
  bool _isRestoring = false;

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
              _sectionTitle('Your Progress'),
              SizedBox(height: 10),
              _buildLevelCard(),
              SizedBox(height: 12),
              _buildStatsGrid(),
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
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showEditProfileSheet(context),
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
              onPressed: () {},
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

  Widget _buildLevelCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.honeyDark, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Level 8 • Focused Learner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                '700 / 1000 XP',
                style: TextStyle(
                  color: AppColors.honeyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.7,
              minHeight: 9,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.honeyDark),
            ),
          ),
          SizedBox(height: 7),
          Text(
            '300 XP to Level 9',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      ('Total Study Time', '42h', Icons.schedule, AppColors.honeyDark),
      ('Sessions Completed', '28', Icons.task_alt, AppColors.successGreen),
      ('Active Subjects', '6', Icons.menu_book, Color(0xFF42A5F5)),
      ('Achievements', '12', Icons.emoji_events, AppColors.accentOrange),
      (
        'Current Streak',
        '8 days',
        Icons.local_fire_department,
        AppColors.errorRed,
      ),
      ('Longest Streak', '21 days', Icons.bolt, AppColors.purpleAccent),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _PressableStatCard(
          label: stat.$1,
          value: stat.$2,
          icon: stat.$3,
          color: stat.$4,
          onPress: () => widget.onPressStat?.call(stat.$1),
        );
      },
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
      padding: EdgeInsets.symmetric(vertical: 4),
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
          onTap: () {},
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
            onTap: () {},
          ),
          Divider(
            height: 1,
            indent: 58,
            endIndent: 14,
            color: AppColors.honeyCombLine.withValues(alpha: 0.45),
          ),
          ListTile(
            leading: _isRestoring
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.honeyDark,
                    ),
                  )
                : Icon(Icons.restore, color: AppColors.honeyDark),
            title: Text('Restore Purchases', style: _menuText()),
            onTap: _isRestoring ? null : _restorePurchases,
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
      child: child,
    );
  }

  BoxShadow _shadow() => BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 14,
    offset: Offset(0, 5),
  );

  Future<void> _restorePurchases() async {
    setState(() => _isRestoring = true);
    await Future<void>.delayed(Duration(milliseconds: 900));
    if (mounted) setState(() => _isRestoring = false);
  }

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

  void _showEditProfileSheet(BuildContext context) {
    final nameController = TextEditingController(text: _name);
    final usernameController = TextEditingController(text: _username);
    final bioController = TextEditingController(text: _bio);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16),
              _editField('Display name', nameController),
              _editField('Username', usernameController, prefix: '@'),
              _editField('Bio', bioController, maxLines: 2),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _name = nameController.text.trim().isEmpty
                          ? _name
                          : nameController.text.trim();
                      _username =
                          usernameController.text
                              .trim()
                              .replaceFirst('@', '')
                              .isEmpty
                          ? _username
                          : usernameController.text.trim().replaceFirst(
                              '@',
                              '',
                            );
                      _bio = bioController.text.trim().isEmpty
                          ? _bio
                          : bioController.text.trim();
                    });
                    Navigator.pop(sheetContext);
                  },
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editField(
    String label,
    TextEditingController controller, {
    String? prefix,
    int maxLines = 1,
  }) => Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, prefixText: prefix),
    ),
  );

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

class _PressableStatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onPress;

  const _PressableStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onPress,
  });

  @override
  State<_PressableStatCard> createState() => _PressableStatCardState();
}

class _PressableStatCardState extends State<_PressableStatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(widget.icon, color: widget.color, size: 19),
              ),
              SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.value,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      widget.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
