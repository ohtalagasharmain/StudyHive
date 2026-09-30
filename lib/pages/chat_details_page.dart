import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import '../services/app_state.dart';
import 'edit_hive_page.dart';
import 'pdf_viewer_page.dart';

class ChatDetailsPage extends StatefulWidget {
  final String hiveId;
  final String hiveName;

  const ChatDetailsPage({
    super.key,
    required this.hiveId,
    required this.hiveName,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  bool _notificationsEnabled = true;

  void _showAddMemberDialog(BuildContext context, HiveData hive) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Hive Member'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Member Name',
            hintText: 'Enter student name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                AppState().addMember(hive.id, name);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name added to ${hive.name}!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.honeyDark),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final hive = AppState().hives.firstWhere(
          (h) => h.id == widget.hiveId,
          orElse: () => HiveData(
            id: widget.hiveId,
            name: widget.hiveName,
            subject: 'Study Group',
            members: 7,
          ),
        );

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
                'Group Info',
                style: TextStyle(color: AppColors.honeyDark, fontWeight: FontWeight.bold),
              ),
              actions: [
                if (hive.owned)
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.honeyDark),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditHivePage(
                            hiveId: hive.id,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hive Info Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: hive.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(hive.icon, style: const TextStyle(fontSize: 36)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          hive.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${hive.subject} • ${hive.membersList.length} Members',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.honeyYellow.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${hive.mastery}% Group Mastery',
                                style: const TextStyle(
                                  color: AppColors.honeyDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notifications Setting Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: SwitchListTile(
                      value: _notificationsEnabled,
                      activeColor: AppColors.honeyDark,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                      title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(_notificationsEnabled ? 'Mute group chat alerts' : 'Notifications muted'),
                      secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.honeyDark),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Members Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Members (${hive.membersList.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddMemberDialog(context, hive),
                        icon: const Icon(Icons.person_add_alt_1, size: 18),
                        label: const Text('Add'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.honeyDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Members List
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: hive.membersList.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final member = entry.value;
                        final isYou = member == 'You' || member == AppState().user.name;

                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isYou
                                    ? AppColors.honeyDark
                                    : AppColors.honeyYellow.withValues(alpha: 0.5),
                                child: Text(
                                  member[0].toUpperCase(),
                                  style: TextStyle(
                                    color: isYou ? Colors.white : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                member,
                                style: TextStyle(
                                  fontWeight: isYou ? FontWeight.bold : FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(idx == 0 ? 'Admin / Creator' : 'Member'),
                              trailing: (!isYou && hive.owned)
                                  ? IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.errorRed),
                                      onPressed: () {
                                        AppState().removeMember(hive.id, member);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$member removed.')),
                                        );
                                      },
                                    )
                                  : null,
                            ),
                            if (idx < hive.membersList.length - 1)
                              const Divider(height: 1, indent: 60),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Shared Materials Header
                  Text(
                    'Shared Group Materials (${hive.materials.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (hive.materials.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          'No materials uploaded to this group yet.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: hive.materials.map((m) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(m.icon, color: m.color),
                          title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(m.date),
                          onTap: () {
                            if ((m.type == StudyMaterialType.pdf || m.type == StudyMaterialType.image) && m.path.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PdfViewerPage(
                                    title: m.title,
                                    path: m.path,
                                    isUrl: m.path.startsWith('http'),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )).toList(),
                    ),

                  const SizedBox(height: 24),

                  // Leave Hive Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Leave Hive?'),
                            content: Text('Are you sure you want to leave ${hive.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  AppState().removeMember(hive.id, AppState().user.name);
                                  Navigator.pop(dialogContext);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Left ${hive.name}.')),
                                  );
                                },
                                style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
                                child: const Text('Leave Group'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.exit_to_app, color: AppColors.errorRed),
                      label: const Text('Leave Study Group', style: TextStyle(color: AppColors.errorRed)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.errorRed),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
