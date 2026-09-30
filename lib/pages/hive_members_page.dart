import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../widgets/reusable_widgets.dart';
import '../services/app_state.dart';

class HiveMembersPage extends StatefulWidget {
  final String hiveId;
  const HiveMembersPage({super.key, required this.hiveId});

  @override
  State<HiveMembersPage> createState() => _HiveMembersPageState();
}

class _HiveMembersPageState extends State<HiveMembersPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final hive = AppState().hives.firstWhere((h) => h.id == widget.hiveId);
        final members = hive.membersList.where((m) => 
          m.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

        return HoneycombBackground(
          showGradient: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: AppColors.honeyDark),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Members',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    hintText: 'Search members...',
                                    prefixIcon: const Icon(Icons.search, color: AppColors.honeyDark),
                                    filled: true,
                                    fillColor: AppColors.cardWhite,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () => _showInviteBottomSheet(hive.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.honeyYellow.withValues(alpha: 0.4),
                                  foregroundColor: AppColors.honeyDark,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.person_add, size: 18),
                                label: const Text('Invite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ...members.map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildMemberCard(m, hive),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemberCard(String name, HiveData hive) {
    final isMe = name == 'You' || name == AppState().user.name;
    final isAdmin = name == 'You' || name == 'Jai'; // Mock admin status

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.honeyYellow.withValues(alpha: 0.2),
            child: Text(name[0].toUpperCase(), 
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.honeyDark, fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    if (isAdmin)
                      const Icon(Icons.shield, color: AppColors.accentOrange, size: 16),
                  ],
                ),
                Text(isAdmin ? 'Admin' : 'Member', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          if (!isMe && (AppState().user.name == 'Jai' || hive.owned)) // Only owners can remove
            IconButton(
              icon: const Icon(Icons.person_remove, color: AppColors.errorRed),
              onPressed: () => _confirmRemove(name, hive.id),
            ),
        ],
      ),
    );
  }

  void _confirmRemove(String name, String hiveId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member?'),
        content: Text('Are you sure you want to remove $name from this hive?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              AppState().removeMember(hiveId, name);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showInviteBottomSheet(String hiveId) {
    final nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Member', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Enter member name'),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Add to Hive',
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  AppState().addMember(hiveId, nameController.text);
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
