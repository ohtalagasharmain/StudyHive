import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/honeycomb_background.dart';

class ChatPage extends StatefulWidget {
  final bool embedded;
  const ChatPage({super.key, this.embedded = false});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _msgController = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {'sender': 'system', 'text': '📢 Reminder: Tomorrow quiz on Newton\'s Laws. Good luck everyone!', 'time': '9:00 AM'},
    {'sender': 'Jai', 'avatar': Colors.blue, 'text': 'Thanks for the reminder! Just finished reviewing 👀', 'time': '9:05 AM', 'isYou': false},
    {'sender': 'You', 'avatar': AppColors.honeyDark, 'text': 'Same! Does anyone have the formula sheet?', 'time': '9:08 AM', 'isYou': true},
    {'sender': 'Derick', 'avatar': Colors.orange, 'text': 'I uploaded it! Check the materials tab 📄', 'time': '9:10 AM', 'isYou': false},
    {'sender': 'You', 'avatar': AppColors.honeyDark, 'text': 'Perfect, thanks Derick! 🙌', 'time': '9:11 AM', 'isYou': true},
  ];

  @override
  void dispose() {
    _msgController.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        if (!widget.embedded)
          AppBar(
            backgroundColor: AppColors.creamLight,
            elevation: 0,
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.honeyDark)),
            title: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.blue.withValues(alpha: 0.2), child: Text('🧪', style: TextStyle(fontSize: 18))),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Physics Hive Chat', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('5 members • 2 online', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.videocam, color: AppColors.honeyDark)),
              IconButton(onPressed: () {}, icon: Icon(Icons.call, color: AppColors.honeyDark)),
            ],
          ),
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, i) {
              final m = _messages[i];
              if (m['sender'] == 'system') return _buildSystemMsg(m);
              return _buildMsg(m);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: Offset(0, -4))],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline, color: AppColors.honeyDark)),
                IconButton(onPressed: () {}, icon: Icon(Icons.attach_file, color: AppColors.textSecondary)),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: AppColors.creamBackground,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_msgController.text.trim().isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'sender': 'You',
                          'avatar': AppColors.honeyDark,
                          'text': _msgController.text.trim(),
                          'time': 'Now',
                          'isYou': true,
                        });
                        _msgController.clear();
                      });
                      Future.delayed(Duration(milliseconds: 200), () {
                        _scroll.animateTo(_scroll.position.maxScrollExtent + 80, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.honeyDark, shape: BoxShape.circle),
                    child: Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    if (widget.embedded) return body;
    return HoneycombBackground(
      showGradient: false,
      child: Scaffold(backgroundColor: Colors.transparent, body: SafeArea(child: body)),
    );
  }

  Widget _buildMsg(Map<String, dynamic> m) {
    final isYou = m['isYou'] as bool;
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isYou) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: (m['avatar'] as Color).withValues(alpha: 0.2),
              child: Text(m['sender'].toString()[0], style: TextStyle(color: m['avatar'] as Color, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isYou)
                  Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(m['sender'], style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                Container(
                  constraints: BoxConstraints(maxWidth: 260),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isYou ? AppColors.honeyDark : AppColors.cardWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: isYou ? Radius.circular(16) : Radius.circular(4),
                      bottomRight: isYou ? Radius.circular(4) : Radius.circular(16),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
                    border: isYou ? null : Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
                  ),
                  child: Text(m['text'], style: TextStyle(color: isYou ? Colors.white : AppColors.textPrimary, fontSize: 14, height: 1.4)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(m['time'], style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ),
              ],
            ),
          ),
          if (isYou) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: (m['avatar'] as Color).withValues(alpha: 0.2),
              child: Text('C', style: TextStyle(color: m['avatar'] as Color, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemMsg(Map<String, dynamic> m) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.honeyYellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.honeyYellow.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Text(m['text'], style: TextStyle(fontSize: 11, color: AppColors.honeyDark, fontWeight: FontWeight.w600)),
              SizedBox(height: 2),
              Text(m['time'], style: TextStyle(fontSize: 9, color: AppColors.honeyDark.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ),
    );
  }
}
