import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'create_hive_page.dart';
import 'join_hive_page.dart';
import 'hive_overview_page.dart';

class HivesPage extends StatefulWidget {
  const HivesPage({super.key});

  @override
  State<HivesPage> createState() => _HivesPageState();
}

final List<Map<String, dynamic>> studyHiveHives = [
  {
    'name': 'Physics Hive',
    'subject': 'Physics',
    'members': 7,
    'mastery': 78,
    'icon': '🧪',
    'color': Color(0xFF42A5F5),
    'owned': true,
    'joined': true,
    'favorite': true,
    'membersList': ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
    'latestMessage': 'Jai: Just finished reviewing the formula sheet.',
    'latestMessageTime': '9:11 AM',
    'unreadMessages': 2,
  },
  {
    'name': 'Math Scholars',
    'subject': 'Mathematics',
    'members': 7,
    'mastery': 65,
    'icon': '📐',
    'color': Color(0xFF7E57C2),
    'owned': false,
    'joined': true,
    'favorite': false,
    'membersList': ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
    'latestMessage': 'Matthew: The practice set is ready.',
    'latestMessageTime': 'Yesterday',
    'unreadMessages': 0,
  },
  {
    'name': 'Biology Buddies',
    'subject': 'Biology',
    'members': 7,
    'mastery': 82,
    'icon': '🌿',
    'color': Color(0xFF66BB6A),
    'owned': false,
    'joined': true,
    'favorite': true,
    'membersList': ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
    'latestMessage': 'Kirs: Shared the review notes.',
    'latestMessageTime': 'Mon',
    'unreadMessages': 1,
  },
  {
    'name': 'Research Circle',
    'subject': 'Research',
    'members': 7,
    'mastery': 45,
    'icon': '🔬',
    'color': AppColors.honeyDark,
    'owned': true,
    'joined': false,
    'favorite': false,
    'membersList': ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
    'latestMessage': 'Clarine: Let\'s review the outline.',
    'latestMessageTime': 'Sun',
    'unreadMessages': 0,
  },
  {
    'name': 'Chemistry Group',
    'subject': 'Chemistry',
    'members': 7,
    'mastery': 70,
    'icon': '⚗️',
    'color': Color(0xFFEF5350),
    'owned': false,
    'joined': true,
    'favorite': false,
    'membersList': ['Jai', 'Kirs', 'Derick', 'Kester', 'Clarine', 'Audrey', 'Matthew'],
    'latestMessage': 'Kester: Does anyone have the worksheets?',
    'latestMessageTime': 'Sat',
    'unreadMessages': 0,
  },
];

class _HivesPageState extends State<HivesPage> {
  final _searchController = TextEditingController();
  String? _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Owned', 'Joined', 'Favorites'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'My Hives',
                  style:
                      Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.honeyDark,
                        fontWeight: FontWeight.bold,
                      ) ??
                      Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search Hives...',
                  prefixIcon: Icon(Icons.search, color: AppColors.honeyDark),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters
                    .map(
                      (f) => Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: _selectedFilter == f,
                          selectedColor: AppColors.honeyDark,
                          backgroundColor: AppColors.cardWhite,
                          labelStyle: TextStyle(
                            color: _selectedFilter == f
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.honeyYellow),
                          ),
                          onSelected: (_) =>
                              setState(() => _selectedFilter = f),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateHivePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.honeyYellow.withValues(
                        alpha: 0.5,
                      ),
                      foregroundColor: AppColors.honeyDark,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.add),
                    label: Text(
                      'Create Hive',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => JoinHivePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardWhite,
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppColors.honeyYellow),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.group_add),
                    label: Text(
                      'Join Hive',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            ...studyHiveHives
                .where((hive) {
                  final query = _searchController.text.toLowerCase();
                  final matchesSearch =
                      hive['name'].toString().toLowerCase().contains(query) ||
                      hive['subject'].toString().toLowerCase().contains(
                        query,
                      ) ||
                      (hive['membersList'] as List<String>).any(
                        (member) => member.toLowerCase().contains(query),
                      );
                  final matchesFilter =
                      _selectedFilter == 'All' ||
                      (_selectedFilter == 'Owned' && hive['owned'] == true) ||
                      (_selectedFilter == 'Joined' &&
                          hive['joined'] == true &&
                          hive['owned'] != true) ||
                      (_selectedFilter == 'Favorites' &&
                          hive['favorite'] == true);
                  return matchesSearch && matchesFilter;
                })
                .map((hive) => _buildHiveCard(context, hive)),
            if (!studyHiveHives.any((hive) {
              final query = _searchController.text.toLowerCase();
              final matchesSearch =
                  hive['name'].toString().toLowerCase().contains(query) ||
                  hive['subject'].toString().toLowerCase().contains(query) ||
                  (hive['membersList'] as List<String>).any(
                    (member) => member.toLowerCase().contains(query),
                  );
              final matchesFilter =
                  _selectedFilter == 'All' ||
                  (_selectedFilter == 'Owned' && hive['owned'] == true) ||
                  (_selectedFilter == 'Joined' &&
                      hive['joined'] == true &&
                      hive['owned'] != true) ||
                  (_selectedFilter == 'Favorites' && hive['favorite'] == true);
              return matchesSearch && matchesFilter;
            }))
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No hives found',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHiveCard(BuildContext context, Map<String, dynamic> hive) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HiveOverviewPage(
                hiveId: hive['name'].toString().toLowerCase().replaceAll(
                  ' ',
                  '-',
                ),
                hiveName: hive['name'].toString(),
                hiveSubject: hive['subject'].toString(),
                hiveMembers: hive['members'] as int,
                hiveIcon: hive['icon'].toString(),
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (hive['color'] as Color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(hive['icon'], style: TextStyle(fontSize: 28)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hive['name'],
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${hive['members']} members',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      hive['subject'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: hive['mastery'] / 100,
                              minHeight: 6,
                              backgroundColor: AppColors.progressBg,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                hive['color'] as Color,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '${hive['mastery']}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hive['color'] as Color,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
