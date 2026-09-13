import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';
import 'chat_details_page.dart';
import 'hive_overview_page.dart';
import 'quiz_selection_page.dart';
import 'study_materials_page.dart';

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
  final _messages = <_MessengerMessage>[
    const _MessengerMessage(
      sender: 'Jai',
      initial: 'J',
      text: 'Hello, everyone!.',
      time: '9:05 AM',
    ),
    const _MessengerMessage(
      sender: 'You',
      initial: 'Y',
      text: 'hello, Jai! I will upload the PPT later.',
      time: '9:08 AM',
      isOutgoing: true,
    ),
    const _MessengerMessage(
      sender: 'Kirs',
      initial: 'K',
      text: 'Thanks, Kirs!',
      time: '9:11 AM',
    ),
    const _MessengerMessage(
      sender: 'Derick',
      initial: 'D',
      text: 'I\'ll check the schedule.',
      time: '9:15 AM',
    ),
    const _MessengerMessage(
      sender: 'Kester',
      initial: 'K',
      text: 'Ready for the session.',
      time: '9:20 AM',
    ),
    const _MessengerMessage(
      sender: 'Clarine',
      initial: 'C',
      text: 'See you all later!',
      time: '9:25 AM',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => _openDetails(context),
                  child: _ChatHeader(
                    hiveName: widget.hiveName,
                    memberSummary: widget.memberSummary,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: 'Chat details',
                    icon: const Icon(Icons.info_outline_rounded),
                    onPressed: () => _openDetails(context),
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
                itemCount: _messages.length + 1,
                itemBuilder: (context, index) => index == 0
                    ? const _PinnedAnnouncement()
                    : _messageBubble(_messages[index - 1]),
              ),
            ),
            _composer(),
          ],
        ),
        bottomNavigationBar: widget.showBottomNavigationBar
            ? _chatNavigationBar(context)
            : null,
      ),
    );
  }

  Widget _chatNavigationBar(BuildContext context) => NavigationBar(
    selectedIndex: 3,
    backgroundColor: AppColors.cardWhite,
    indicatorColor: AppColors.honeyYellow.withValues(alpha: 0.45),
    height: 72,
    onDestinationSelected: (index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HiveOverviewPage()),
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

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatDetailsPage(hiveId: widget.hiveId, hiveName: widget.hiveName),
      ),
    );
  }

  Widget _messageBubble(_MessengerMessage message) {
    final messageBody = Column(
      crossAxisAlignment: message.isOutgoing
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 310),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: BoxDecoration(
            color: message.isOutgoing ? const Color(0xFFD97706) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
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
                ? [messageBody]
                : [
                    _avatar(message.initial, false),
                    const SizedBox(width: 8),
                    messageBody,
                  ],
          ),
        ],
      ),
    );
  }

  Widget _avatar(String initial, bool outgoing) => CircleAvatar(
    radius: 16,
    backgroundColor: outgoing ? const Color(0xFFD97706) : AppColors.honeyYellow,
    child: Text(
      initial,
      style: TextStyle(
        color: outgoing ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

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
            onPressed: () {},
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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _MessengerMessage(
          sender: 'You',
          initial: 'Y',
          text: text,
          time: 'Now',
          isOutgoing: true,
        ),
      );
      _messageController.clear();
    });
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
}

class _ChatHeader extends StatelessWidget {
  final String hiveName;
  final String memberSummary;

  const _ChatHeader({required this.hiveName, required this.memberSummary});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(backgroundColor: Color(0x3342A5F5), child: Text('🧪')),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hiveName,
            style: TextStyle(
              color: AppColors.honeyDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Text(
            memberSummary,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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

class _MessengerMessage {
  final String sender;
  final String initial;
  final String text;
  final String time;
  final bool isOutgoing;

  const _MessengerMessage({
    required this.sender,
    required this.initial,
    required this.text,
    required this.time,
    this.isOutgoing = false,
  });
}
