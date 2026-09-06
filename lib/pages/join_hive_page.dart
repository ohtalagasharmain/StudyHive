import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import 'hive_overview_page.dart';

class JoinHivePage extends StatefulWidget {
  const JoinHivePage({super.key});

  @override
  State<JoinHivePage> createState() => _JoinHivePageState();
}

class _JoinHivePageState extends State<JoinHivePage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _showPreview = false;
  bool _isJoining = false;

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {
      _showPreview = _code.length == 6;
    });
  }

  void _handleJoin() {
    if (_code.length == 6) {
      setState(() => _isJoining = true);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HiveOverviewPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: AppColors.honeyDark),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Join a Hive',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox(height: 28),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.purpleAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.group_add, color: AppColors.purpleAccent, size: 48),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Enter the 6-digit join code',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Ask the hive creator for the code',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.honeyDark),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.honeyYellow, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.honeyYellow, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.honeyDark, width: 2.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onChanged: (v) => _onDigitChanged(index, v),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 32),
                if (_showPreview) _buildPreviewCard(),
                SizedBox(height: 32),
                PrimaryButton(
                  text: 'Join Hive',
                  icon: Icons.login,
                  isLoading: _isJoining,
                  onPressed: _code.length == 6 ? _handleJoin : null,
                  backgroundColor: _showPreview ? AppColors.purpleAccent : null,
                ),
                SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.purpleAccent.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hive Preview',
            style: TextStyle(
              color: AppColors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Color(0xFF42A5F5).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text('🧪', style: TextStyle(fontSize: 26))),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Physics Hive',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('24 members', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        SizedBox(width: 16),
                        Icon(Icons.person, size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Created by Claire', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'A hive dedicated to mastering Physics concepts through collaborative learning.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.creamBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Newton\'s Laws', style: TextStyle(fontSize: 11, color: AppColors.honeyDark, fontWeight: FontWeight.w600)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.creamBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Kinematics', style: TextStyle(fontSize: 11, color: AppColors.honeyDark, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
