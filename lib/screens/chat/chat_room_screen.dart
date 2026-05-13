import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../repositories/firestore_repository.dart';
import '../../providers/user_provider.dart';
import '../../models/chat_message_model.dart';
import '../../providers/user_provider.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  const ChatRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() { _msgCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    final msg = ChatMessageModel(
      id: '', roomId: widget.roomId, senderId: user.uid,
      senderName: user.displayName ?? 'User', content: text, createdAt: DateTime.now(),
    );
    await ref.read(firestoreRepositoryProvider).sendMessage(msg);
  }

  @override
  Widget build(BuildContext context) {
    final msgsAsync = ref.watch(chatMessagesProvider(widget.roomId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: msgsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (_, __) => const Center(child: Text('Could not load messages', style: TextStyle(color: AppColors.textSecondary))),
              data: (msgs) {
                final userId = ref.read(authStateProvider).valueOrNull?.uid;
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i];
                    final isMe = m.senderId == userId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.bgCard,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14), topRight: const Radius.circular(14),
                            bottomLeft: Radius.circular(isMe ? 14 : 4), bottomRight: Radius.circular(isMe ? 4 : 14),
                          ),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          if (!isMe) Text(m.senderName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: AppColors.primary.withValues(alpha: 0.8))),
                          Text(m.content, style: TextStyle(fontSize: 14, color: isMe ? Colors.white : AppColors.textPrimary)),
                        ]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.bgSecondary,
              border: Border(top: BorderSide(color: AppColors.textMuted.withValues(alpha: 0.1)))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _msgCtrl, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    decoration: InputDecoration(hintText: 'Type a message...', hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.send, color: Colors.white, size: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
