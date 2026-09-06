import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.honeyDark,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.honeyDark,
          side: BorderSide(color: AppColors.honeyDark, width: 2),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 20), SizedBox(width: 8)],
            Text(text),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? hintText;
  final int? maxLines;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.honeyDark)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final int current;
  final int total;
  final IconData icon;
  final Color? color;

  const ProgressCard({
    super.key,
    required this.title,
    required this.current,
    required this.total,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;
    final cardColor = color ?? AppColors.honeyYellow;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: cardColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '$current/$total',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(cardColor),
            ),
          ),
        ],
      ),
    );
  }
}

class HiveCard extends StatelessWidget {
  final String name;
  final String subject;
  final int memberCount;
  final int mastery;
  final String code;
  final VoidCallback? onEnter;
  final VoidCallback? onDelete;
  final String? createdBy;
  final String? createdAt;

  const HiveCard({
    super.key,
    required this.name,
    required this.subject,
    required this.memberCount,
    required this.mastery,
    this.code = '',
    this.onEnter,
    this.onDelete,
    this.createdBy,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.textPrimary),
                    ),
                    if (createdBy != null)
                      Text(
                        'Created by $createdBy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.creamBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people, size: 16, color: AppColors.honeyDark),
                    SizedBox(width: 4),
                    Text(
                      '$memberCount members',
                      style: TextStyle(
                        color: AppColors.honeyDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (code.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.creamLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.honeyYellow.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Room Code: $code',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  TextButton(onPressed: () {}, child: Text('Copy')),
                ],
              ),
            ),
          SizedBox(height: 12),
          Text(subject, style: Theme.of(context).textTheme.titleMedium),
          if (createdAt != null) ...[
            SizedBox(height: 8),
            Text(
              'Created $createdAt',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Group Mastery',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '$mastery%',
                          style: TextStyle(
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: mastery / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.progressBg,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.successGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onEnter != null || onDelete != null) ...[
            SizedBox(height: 16),
            Row(
              children: [
                if (onEnter != null)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 49, 26, 0),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onEnter,
                      child: Text('Enter Room'),
                    ),
                  ),
                if (onEnter != null && onDelete != null) SizedBox(width: 12),
                if (onDelete != null)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onDelete,
                      child: Text('Delete'),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String? actionText;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.actionText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        if (trailing != null)
          trailing!
        else if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: Text(actionText ?? 'See All')),
      ],
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
            _buildNavItem(1, Icons.hive_outlined, Icons.hive, 'Hives'),
            _buildCenterButton(context),
            _buildNavItem(
              2,
              Icons.chat_bubble_outline,
              Icons.chat_bubble,
              'Chat',
            ),
            _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.honeyDark : AppColors.textSecondary,
              size: 26,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.honeyDark
                    : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(4),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.honeyDark,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.honeyDark.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
