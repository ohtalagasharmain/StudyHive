import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';

class HiveMembersPage extends StatefulWidget {
  const HiveMembersPage({super.key});

  @override
  State<HiveMembersPage> createState() => _HiveMembersPageState();
}

class _HiveMembersPageState extends State<HiveMembersPage> {
  final List<Map<String, dynamic>> _members = [
    {
      'name': 'You (Studyhive)',
      'streak': 8,
      'mastery': 88,
      'badge': '🎖️ Admin',
      'isAdmin': true,
      'color': AppColors.honeyDark,
    },
    {
      'name': 'Jai',
      'streak': 12,
      'mastery': 76,
      'badge': '🔥 Top Contributor',
      'isAdmin': true,
      'color': Color(0xFF42A5F5),
    },
    {
      'name': 'Kirs',
      'streak': 3,
      'mastery': 65,
      'badge': '📘 Study Bee',
      'color': Color(0xFFEC407A),
    },
    {
      'name': 'Derick',
      'streak': 5,
      'mastery': 70,
      'badge': '⭐ Active',
      'color': AppColors.accentOrange,
    },
    {
      'name': 'Kester',
      'streak': 7,
      'mastery': 72,
      'badge': '🚀 Fast Learner',
      'color': AppColors.purpleAccent,
    },
    {
      'name': 'Clarine',
      'streak': 4,
      'mastery': 68,
      'badge': '🔬 Researcher',
      'color': AppColors.successGreen,
    },
    {
      'name': 'Audrey',
      'streak': 1,
      'mastery': 60,
      'badge': '🌱 New Member',
      'color': AppColors.accentOrange,
    },
    {
      'name': 'Matthew',
      'streak': 6,
      'mastery': 75,
      'badge': '📐 Math Wiz',
      'color': Color(0xFF7E57C2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: AppColors.honeyDark),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Members',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search members...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.honeyDark,
                                ),
                                filled: true,
                                fillColor: AppColors.cardWhite,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AppColors.honeyYellow.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => _showInviteBottomSheet(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.honeyYellow.withValues(
                                alpha: 0.4,
                              ),
                              foregroundColor: AppColors.honeyDark,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.person_add, size: 18),
                            label: Text(
                              'Invite',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ..._members.map(
                        (m) => Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: _buildMemberCard(m),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: (member['color'] as Color).withValues(
                  alpha: 0.2,
                ),
                child: Text(
                  member['name']
                      .toString()
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: member['color'] as Color,
                    fontSize: 18,
                  ),
                ),
              ),
              if (member['isAdmin'] == true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield,
                      color: AppColors.accentOrange,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.creamBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member['badge'].toString().split(' ').last,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: AppColors.accentOrange,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${member['streak']} day streak',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 14),
                          Icon(
                            Icons.bar_chart,
                            size: 14,
                            color: AppColors.successGreen,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${member['mastery']}%',
                            style: TextStyle(
                              color: AppColors.successGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: member['mastery'] / 100,
                    minHeight: 5,
                    backgroundColor: AppColors.progressBg,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      member['color'] as Color,
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

  void _showInviteBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.honeyCombLine,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Invite Member',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Share the join code or send invite via',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.creamBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.honeyYellow),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['6', '7', '6', '2', '9', '9']
                      .map(
                        (c) => Container(
                          width: 36,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.honeyDark),
                          ),
                          child: Center(
                            child: Text(
                              c,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.honeyDark,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.copy, color: AppColors.honeyDark),
                  label: Text(
                    'Copy Code',
                    style: TextStyle(
                      color: AppColors.honeyDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildInviteOption(
                    Icons.email,
                    'Email',
                    Color.fromARGB(0, 66, 164, 245),
                  ),
                  SizedBox(width: 12),
                  _buildInviteOption(
                    Icons.message,
                    'SMS',
                    const Color.fromARGB(0, 102, 187, 106),
                  ),
                  SizedBox(width: 12),
                  _buildInviteOption(
                    Icons.share,
                    'Share',
                    const Color.fromARGB(0, 126, 87, 194),
                  ),
                  SizedBox(width: 12),
                  _buildInviteOption(
                    Icons.qr_code,
                    'QR Code',
                    AppColors.textPrimary,
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteOption(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
