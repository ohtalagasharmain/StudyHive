import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';

class CreateHivePage extends StatefulWidget {
  const CreateHivePage({super.key});

  @override
  State<CreateHivePage> createState() => _CreateHivePageState();
}

class _CreateHivePageState extends State<CreateHivePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _customSubjectController = TextEditingController();
  String? _selectedSubject = 'Physics';
  String _privacy = 'Private (Only invite)';
  bool _isCreating = false;
  bool _showSuccess = false;
  String _generatedCode = '';

  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Filipino',
    'Social Studies',
    'History',
    'Research',
     'Custom',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _customSubjectController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isCreating = true);
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isCreating = false;
          _generatedCode = List.generate(
            6,
            (_) => (0 + (9 * (0.5 + 0.5)).toInt()).toString(),
          ).join();
          _showSuccess = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessScreen();
    }
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.honeyDark,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Create a Hive',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.honeyYellow.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.hive,
                        color: AppColors.honeyDark,
                        size: 48,
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  CustomTextField(
                    label: 'Hive Name',
                    controller: _nameController,
                    hintText: 'e.g. Chemistry Group',
                    prefixIcon: Icons.group,
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Please enter a hive name' : null,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Subject',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.honeyYellow,
                            width: 2,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSubject,
                            isExpanded: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            items: _subjects
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedSubject = v),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                  if (_selectedSubject == 'Custom') ...[
                    SizedBox(height: 12),
                    CustomTextField(
                      label: 'Custom Subject',
                      controller: _customSubjectController,
                      hintText: 'e.g. Web Development',
                      prefixIcon: Icons.edit_outlined,
                      validator: (value) {
                        if (_selectedSubject == 'Custom' &&
                            (value?.trim().isEmpty ?? true)) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                  ],
                  CustomTextField(
                    label: 'Description',
                    controller: _descController,
                    hintText: 'Let\'s master Chemistry together!',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  Text(
                    'Privacy',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  _buildPrivacyOption('Private (Only invite)', Icons.lock),
                  SizedBox(height: 8),
                  _buildPrivacyOption('Public (Anyone can join)', Icons.public),
                  SizedBox(height: 8),
                  _buildPrivacyOption(
                    'Private (Created Hive)',
                    Icons.admin_panel_settings,
                  ),
                  SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Create Hive',
                    icon: Icons.check_circle,
                    isLoading: _isCreating,
                    onPressed: _handleCreate,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(String label, IconData icon) {
    final isSelected = _privacy == label;
    return GestureDetector(
      onTap: () => setState(() => _privacy = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.honeyYellow.withValues(alpha: 0.2)
              : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.honeyDark : AppColors.honeyYellow,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.honeyDark, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.honeyDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return HoneycombBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.successGreen,
                          size: 80,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32),
                Text(
                  'Hive Created!',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 12),
                Text(
                  'Share this join code with your classmates',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.honeyYellow.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: AppColors.honeyYellow, width: 3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _generatedCode.split('').map((c) {
                      return Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.honeyYellow.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            c,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.honeyDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                TextButton.icon(
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
                SizedBox(height: 40),
                PrimaryButton(
                  text: 'Go to Hive',
                  icon: Icons.arrow_forward,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
