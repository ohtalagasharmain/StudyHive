import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'study_preferences_page.dart';

class StudentOnboardingPage extends StatefulWidget {
  const StudentOnboardingPage({super.key});

  @override
  State<StudentOnboardingPage> createState() => _StudentOnboardingPageState();
}

class _StudentOnboardingPageState extends State<StudentOnboardingPage> {
  final _nameController = TextEditingController(text: 'Studyhive');
  final _schoolController = TextEditingController(text: 'NU East Ortigas');
  String? _selectedGrade = 'Freshman';
  String? _selectedStrand = 'BSCS';
  final List<String> _selectedSubjects = ['Fundamentals of Programming'];
  final int _currentStep = 0;

  final List<String> _grades = ['Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12', 'College'];
  final List<String> _strands = ['STEM', 'ABM', 'HUMSS', 'GAS', 'TVL', 'N/A'];
  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'Filipino',
    'Social Studies',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    super.dispose();
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
                          'Tell us about you',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.textPrimary,
                              ),
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
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.honeyYellow, borderRadius: BorderRadius.circular(2))),
                    SizedBox(width: 12),
                    _buildStepDot(1),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'This helps us personalize your experience',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.honeyYellow,
                              child: Icon(Icons.person, size: 60, color: AppColors.honeyDark),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.honeyDark,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.cardWhite, width: 3),
                                ),
                                child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          child: Text('Upload Profile Picture'),
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          label: 'Full Name',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                        ),
                        CustomTextField(
                          label: 'School',
                          controller: _schoolController,
                          prefixIcon: Icons.school_outlined,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text('Grade / Year', style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: AppColors.inputBg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.honeyYellow, width: 2),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedGrade,
                                  isExpanded: true,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  items: _grades
                                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                      .toList(),
                                  onChanged: (v) => setState(() => _selectedGrade = v),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text('Course / Strand', style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _strands
                                  .map((s) => ChoiceChip(
                                        label: Text(s),
                                        selected: _selectedStrand == s,
                                        selectedColor: AppColors.honeyDark,
                                        backgroundColor: AppColors.cardWhite,
                                        labelStyle: TextStyle(
                                          color: _selectedStrand == s ? Colors.white : AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(color: AppColors.honeyYellow),
                                        ),
                                        onSelected: (_) => setState(() => _selectedStrand = s),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text('Subjects you want to study', style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _subjects
                                  .map((s) => FilterChip(
                                        label: Text(s),
                                        selected: _selectedSubjects.contains(s),
                                        selectedColor: AppColors.honeyDark,
                                        backgroundColor: AppColors.cardWhite,
                                        labelStyle: TextStyle(
                                          color: _selectedSubjects.contains(s) ? Colors.white : AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(color: AppColors.honeyYellow),
                                        ),
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _selectedSubjects.add(s);
                                            } else {
                                              _selectedSubjects.remove(s);
                                            }
                                          });
                                        },
                                        checkmarkColor: Colors.white,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                PrimaryButton(
                  text: 'Continue',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StudyPreferencesPage()),
                    );
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
        color: isActive ? AppColors.honeyDark : AppColors.honeyYellow.withValues(alpha: 0.4),
      ),
    );
  }
}
