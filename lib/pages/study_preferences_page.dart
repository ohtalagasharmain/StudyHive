import 'package:flutter/material.dart';
import '../services/subscription_router.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';


class StudyPreferencesPage extends StatefulWidget {
  const StudyPreferencesPage({super.key});

  @override
  State<StudyPreferencesPage> createState() => _StudyPreferencesPageState();
}

class _StudyPreferencesPageState extends State<StudyPreferencesPage> {
  String? _selectedGoal = 'Improve Grades';
  String? _selectedTime = 'Evening (6PM - 10PM)';
  String? _selectedDuration = '1 - 2 Hours';
  final _examController = TextEditingController(text: 'Physics Midterms');
  DateTime? _examDate = DateTime(2026, 6, 15);

  final List<String> _goals = [
    'Improve Grades',
    'Pass Exams',
    'Learn New Topics',
    'Review for Tests',
    'Master Subjects',
  ];
  final List<String> _studyTimes = [
    'Morning (6AM - 10AM)',
    'Afternoon (1PM - 5PM)',
    'Evening (6PM - 10PM)',
    'Late Night (10PM - 2AM)',
    'Flexible',
  ];
  final List<String> _durations = [
    '30 mins - 1 Hour',
    '1 - 2 Hours',
    '2 - 4 Hours',
    '4+ Hours',
  ];

  final int _currentStep = 1;

  @override
  void dispose() {
    _examController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.honeyDark),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: AppColors.honeyDark),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Your Study Preferences',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepDot(0),
                    SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.honeyDark,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildStepDot(1),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Almost done!',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Study Goal',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _goals
                              .map(
                                (g) => ChoiceChip(
                                  avatar: Icon(
                                    g == 'Improve Grades'
                                        ? Icons.trending_up
                                        : g == 'Pass Exams'
                                        ? Icons.assignment_turned_in
                                        : g == 'Learn New Topics'
                                        ? Icons.lightbulb
                                        : g == 'Review for Tests'
                                        ? Icons.auto_stories
                                        : Icons.star,
                                    size: 18,
                                    color: _selectedGoal == g
                                        ? Colors.white
                                        : AppColors.honeyDark,
                                  ),
                                  label: Text(g),
                                  selected: _selectedGoal == g,
                                  selectedColor: AppColors.honeyDark,
                                  backgroundColor: AppColors.cardWhite,
                                  labelStyle: TextStyle(
                                    color: _selectedGoal == g
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppColors.honeyYellow,
                                    ),
                                  ),
                                  onSelected: (_) =>
                                      setState(() => _selectedGoal = g),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 28),
                        Text(
                          'Preferred Study Time',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 12),
                        RadioGroup<String>(
                          groupValue: _selectedTime,
                          onChanged: (v) => setState(() => _selectedTime = v),
                          child: Column(
                            children: _studyTimes
                                .map(
                                  (t) => Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Material(
                                      color: AppColors.cardWhite,
                                      borderRadius: BorderRadius.circular(12),
                                      child: RadioListTile<String>(
                                        value: t,
                                        title: Text(t),
                                        activeColor: AppColors.honeyDark,
                                        tileColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: AppColors.honeyYellow,
                                          ),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Daily Study Duration',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 12),
                        RadioGroup<String>(
                          groupValue: _selectedDuration,
                          onChanged: (v) =>
                              setState(() => _selectedDuration = v),
                          child: Column(
                            children: _durations.asMap().entries.map((e) {
                              final i = e.key;
                              final d = e.value;
                              final icons = [
                                Icons.timer_10_select,
                                Icons.timer,
                                Icons.hourglass_bottom,
                                Icons.hourglass_full,
                              ];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _selectedDuration == d
                                          ? AppColors.honeyDark
                                          : AppColors.honeyYellow,
                                      width: _selectedDuration == d ? 2.5 : 1.5,
                                    ),
                                    color: _selectedDuration == d
                                        ? AppColors.honeyYellow.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.cardWhite,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    child: RadioListTile<String>(
                                      value: d,
                                      secondary: Icon(
                                        icons[i],
                                        color: AppColors.honeyDark,
                                      ),
                                      title: Text(d),
                                      activeColor: AppColors.honeyDark,
                                      tileColor: Colors.transparent,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          label: 'Upcoming Exam',
                          controller: _examController,
                          prefixIcon: Icons.event_note,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                'Exam Date',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.inputBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.honeyYellow,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColors.honeyDark,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _examDate != null
                                          ? '${_examDate!.month}/${_examDate!.day}/${_examDate!.year}'
                                          : 'Select date',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                PrimaryButton(
                  text: 'Finish Setup',
                  icon: Icons.check_circle,
                  onPressed: () {
                    SubscriptionRouter.navigateBasedOnSubscription(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(int step) {
    final isActive = step <= _currentStep;
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.honeyDark
            : AppColors.honeyYellow.withValues(alpha: 0.4),
      ),
    );
  }
}
