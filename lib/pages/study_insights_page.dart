import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../services/app_state.dart';

class StudyInsightsPage extends StatelessWidget {
  const StudyInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final streak = AppState().studyStreak;
        final sessions = AppState().sessions;
        final totalMinutes = sessions.fold(0, (sum, s) => sum + s.durationInMinutes);

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
                'Study Insights',
                style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Banner
                  Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInsightStat('Streak', '$streak Days', Icons.local_fire_department, AppColors.accentOrange),
                        _buildInsightStat('Total Time', '$totalMinutes Mins', Icons.timer, AppColors.honeyDark),
                        _buildInsightStat('Sessions', '${sessions.length}', Icons.check_circle_outline, AppColors.successGreen),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('Weekly Activity', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar('Mon', 0.4),
                            _buildBar('Tue', 0.7),
                            _buildBar('Wed', 0.3),
                            _buildBar('Thu', 0.9),
                            _buildBar('Fri', 0.6),
                            _buildBar('Sat', 0.8),
                            _buildBar('Sun', 0.5),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Peak productivity: Thursdays at 4:00 PM',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('Subject Focus Breakdown', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildSubjectRow('Physics', 0.45, AppColors.honeyDark),
                  _buildSubjectRow('Mathematics', 0.30, AppColors.purpleAccent),
                  _buildSubjectRow('Chemistry', 0.15, AppColors.accentOrange),
                  _buildSubjectRow('Biology', 0.10, AppColors.successGreen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInsightStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildBar(String day, double factor) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 100 * factor,
          decoration: BoxDecoration(
            color: AppColors.honeyDark.withValues(alpha: factor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSubjectRow(String subject, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${(percentage * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
