import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'chat_details_page.dart';
import 'hive_overview_page.dart';
import 'quiz_selection_page.dart';
import 'study_materials_page.dart';
import 'pdf_viewer_page.dart';
import '../services/app_state.dart';

class ChatPage extends StatefulWidget {
  final bool showAppBar;
  final bool showBottomNavigationBar;
  final String hiveId;
  final String hiveName;
  final String memberSummary;

  const ChatPage({
    super.key,
    this.showAppBar = true,
    this.showBottomNavigationBar = true,
    this.hiveId = 'physics-hive',
    this.hiveName = 'Physics Hive',
    this.memberSummary = '7 members',
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isAttaching = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _attachFile() async {
    setState(() => _isAttaching = true);

    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'png',
          'jpg',
          'jpeg',
        ],
      );

      if (file != null) {
        final bytes = await file.readAsBytes();

        if (bytes.length > 10 * 1024 * 1024) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size too large. Max 10MB allowed.'),
            ),
          );
          return;
        }

        final now = DateTime.now();
        final timeStr = '${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

        final message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: 'You',
          text: 'Shared file: ${file.name}',
          time: timeStr,
          isOutgoing: true,
          fileName: file.name,
          filePath: file.path ?? file.name,
          isFile: true,
        );

        AppState().sendMessage(widget.hiveId, message);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to attach file: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAttaching = false);
      }
    }
  }
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'You',
      text: text,
      time: TimeOfDay.now().format(context),
      isOutgoing: true,
    );

    AppState().sendMessage(widget.hiveId, newMessage);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        HiveData hive;
        try {
          hive = AppState().hives.firstWhere((h) => h.id == widget.hiveId);
        } catch (_) {
          hive = HiveData(
            id: widget.hiveId,
            name: widget.hiveName,
            subject: '',
            members: 7,
          );
        }

        return HoneycombBackground(
          showGradient: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: widget.showAppBar
                ? AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    titleSpacing: 16,
                    title: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openDetails(context, hive),
                      child: _ChatHeader(
                        hiveName: hive.name,
                        memberSummary: '${hive.members} members',
                        icon: hive.icon,
                      ),
                    ),
                    actions: [
                      IconButton(
                        tooltip: 'Chat details',
                        icon: const Icon(Icons.info_outline_rounded),
                        onPressed: () => _openDetails(context, hive),
                      ),
                    ],
                  )
                : null,
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: hive.messages.length + 1,
                    itemBuilder: (context, index) => index == 0
                        ? const _PinnedAnnouncement()
                        : _messageBubble(hive.messages[index - 1]),
                  ),
                ),
                if (_isAttaching)
                  const LinearProgressIndicator(color: AppColors.honeyDark),
                _composer(),
              ],
            ),
            bottomNavigationBar: widget.showBottomNavigationBar
                ? _chatNavigationBar(context, hive)
                : null,
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, HiveData hive) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailsPage(hiveId: hive.id, hiveName: hive.name),
      ),
    );
  }

  Widget _chatNavigationBar(BuildContext context, HiveData hive) => NavigationBar(
    selectedIndex: 3,
    backgroundColor: AppColors.cardWhite,
    indicatorColor: AppColors.honeyYellow.withValues(alpha: 0.45),
    height: 72,
    onDestinationSelected: (index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HiveOverviewPage(
            hiveId: hive.id,
            hiveName: hive.name,
            hiveSubject: hive.subject,
            hiveIcon: hive.icon,
          )),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudyMaterialsPage()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizSelectionPage()),
        );
      }
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Overview',
      ),
      NavigationDestination(
        icon: Icon(Icons.folder_outlined),
        selectedIcon: Icon(Icons.folder),
        label: 'Materials',
      ),
      NavigationDestination(
        icon: Icon(Icons.quiz_outlined),
        selectedIcon: Icon(Icons.quiz),
        label: 'Quiz',
      ),
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline),
        selectedIcon: Icon(Icons.chat_bubble),
        label: 'Chat',
      ),
    ],
  );

  Widget _messageBubble(ChatMessage message) {
    final isFile = message.isFile;
    final messageBody = Column(
      crossAxisAlignment: message.isOutgoing
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 310),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isOutgoing ? const Color(0xFFD97706) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
            ],
          ),
          child: isFile
              ? InkWell(
                  onTap: () {
                    if (message.filePath != null && message.filePath!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewerPage(
                            title: message.fileName ?? 'Shared File',
                            path: message.filePath!,
                            isUrl: message.filePath!.startsWith('http'),
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFileIcon(message.fileName ?? ''),
                        color: message.isOutgoing ? Colors.white : AppColors.honeyDark,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message.fileName ?? 'Unknown file',
                          style: TextStyle(
                            color: message.isOutgoing ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.open_in_new, 
                          size: 20, 
                          color: message.isOutgoing ? Colors.white70 : AppColors.textSecondary),
                        onPressed: () {
                          if (message.filePath != null && message.filePath!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PdfViewerPage(
                                  title: message.fileName ?? 'Shared File',
                                  path: message.filePath!,
                                  isUrl: message.filePath!.startsWith('http'),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              : Text(
                  message.text,
                  style: TextStyle(
                    color: message.isOutgoing ? Colors.white : AppColors.textPrimary,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          message.time,
          style: TextStyle(
            color: message.isOutgoing
                ? Colors.white70
                : AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isOutgoing
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!message.isOutgoing)
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 4),
              child: Text(
                message.sender,
                style: const TextStyle(
                  color: AppColors.honeyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isOutgoing
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: message.isOutgoing
                ? [
                    messageBody,
                    const SizedBox(width: 8),
                    _avatar(message.sender[0], true),
                  ]
                : [
                    _avatar(message.sender[0], false),
                    const SizedBox(width: 8),
                    messageBody,
                  ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    if (fileName.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) return Icons.description;
    if (fileName.contains(RegExp(r'\.(jpg|jpeg|png)$'))) return Icons.image;
    return Icons.insert_drive_file;
  }

  Widget _avatar(String initial, bool outgoing) {
    final user = AppState().user;
    return CircleAvatar(
      radius: 16,
      backgroundColor: outgoing ? const Color(0xFFD97706) : AppColors.honeyYellow,
      backgroundImage: (outgoing && user.profilePicturePath != null)
          ? FileImage(File(user.profilePicturePath!))
          : null,
      child: (outgoing && user.profilePicturePath != null)
          ? null
          : Text(
              initial.toUpperCase(),
              style: TextStyle(
                color: outgoing ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _composer() => Container(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Attach file',
            onPressed: _attachFile,
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: AppColors.creamLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide(color: AppColors.honeyDark),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Send message',
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ChatHeader extends StatelessWidget {
  final String hiveName;
  final String memberSummary;
  final String icon;

  const _ChatHeader({
    required this.hiveName,
    required this.memberSummary,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(backgroundColor: const Color(0x3342A5F5), child: Text(icon)),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hiveName,
            style: const TextStyle(
              color: AppColors.honeyDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Text(
            memberSummary,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    ],
  );
}

class _PinnedAnnouncement extends StatelessWidget {
  const _PinnedAnnouncement();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFEF3C7),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      children: [
        Text(
          'Welcome to the group chat!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Today • 9:00 AM',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    ),
  );
}
