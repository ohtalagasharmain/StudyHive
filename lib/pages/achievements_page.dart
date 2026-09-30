import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../services/app_state.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      ('5 Day Streak', 'Study 5 consecutive days', Icons.local_fire_department, AppColors.accentOrange, true),
      ('Hive Pioneer', 'Create or join your first study hive', Icons.hive, AppColors.honeyDark, true),
      ('Quiz Scholar', 'Complete 10 adaptive quizzes', Icons.quiz, AppColors.purpleAccent, true),
      ('Resource Collector', 'Save 5 study materials', Icons.bookmark, AppColors.successGreen, true),
      ('Mastermind', 'Achieve 80% mastery in a hive subject', Icons.emoji_events, AppColors.honeyDark, false),
      ('Night Owl', 'Complete a study session after 10 PM', Icons.nights_stay, Colors.indigo, false),
    ];

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
            'Achievements',
            style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.honeyYellow.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events, color: AppColors.honeyDark, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '12 Unlocked Badges',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '4 Badges Unlocked • Level 2 Explorer',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Badges & Milestones', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              ...achievements.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.$5
                            ? item.$4.withValues(alpha: 0.15)
                            : Colors.grey.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.$3,
                        color: item.$5 ? item.$4 : Colors.grey,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: item.$5 ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.$2,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item.$5)
                      const Icon(Icons.check_circle, color: AppColors.successGreen)
                    else
                      const Icon(Icons.lock, color: Colors.grey),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
