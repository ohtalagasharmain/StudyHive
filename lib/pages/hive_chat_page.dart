import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'chat_page.dart';

class HiveChatPage extends StatelessWidget {
  const HiveChatPage({super.key});

  static const List<Map<String, dynamic>> _activeHives = [
    {
      'name': 'Physics Hive',
      'subject': 'Newton\'s Laws',
      'members': 5,
      'preview': 'Jai: Just finished reviewing the formula sheet.',
      'time': '9:11 AM',
      'unread': 2,
      'color': Color(0xFF42A5F5),
      'icon': '🧪',
    },
    {
      'name': 'Math Scholars',
      'subject': 'Calculus Review',
      'members': 18,
      'preview': 'Mina: The practice problems are uploaded.',
      'time': 'Yesterday',
      'unread': 0,
      'color': Color(0xFF7E57C2),
      'icon': '📐',
    },
    {
      'name': 'Biology Buddies',
      'subject': 'Cell Biology',
      'members': 12,
      'preview': 'Leo: Are we meeting after class?',
      'time': 'Mon',
      'unread': 4,
      'color': Color(0xFF66BB6A),
      'icon': '🌿',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(
                'Messages',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 6),
              Text(
                'Choose a hive to view and send messages.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24),
              ..._activeHives.map(
                (hive) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _buildHiveTile(context, hive),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHiveTile(BuildContext context, Map<String, dynamic> hive) {
    final color = hive['color'] as Color;
    final unread = hive['unread'] as int;

    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatPage()),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  hive['icon'] as String,
                  style: TextStyle(fontSize: 24),
                ),
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
                            hive['name'] as String,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          hive['time'] as String,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${hive['members']} members • ${hive['subject']}',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hive['preview'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (unread > 0) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.honeyDark,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unread',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
