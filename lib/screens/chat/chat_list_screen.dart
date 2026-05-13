import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(chatRoomsProvider);
    final currentUserId = ref.watch(authStateProvider).valueOrNull?.uid;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: AppColors.bgSecondary,
              child: Row(children: [
                Container(padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(gradient: AppColors.oceanGradient, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22)),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Messages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Text('Chat with your swap partners', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ])),
              ]),
            ),
            Expanded(
              child: roomsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (_, __) => _emptyState(),
                data: (rooms) {
                  if (rooms.isEmpty) return _emptyState();
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rooms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final room = rooms[i];
                      final otherId = room.participants.firstWhere((id) => id != currentUserId, orElse: () => '');
                      final otherName = room.participantNames[otherId] ?? 'User';
                      final unread = room.unreadCount[currentUserId ?? ''] ?? 0;

                      return GestureDetector(
                        onTap: () => context.go('/chat/${room.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 24, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                child: Text(otherName[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(otherName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  if (room.lastMessage != null)
                                    Text(room.lastMessage!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                ]),
                              ),
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                if (room.lastMessageTime != null)
                                  Text(room.lastMessageTime!.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                if (unread > 0)
                                  Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                                    child: Text('$unread', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600))),
                              ]),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.chat_outlined, color: AppColors.textMuted, size: 48),
      const SizedBox(height: 12),
      const Text('No messages yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      const SizedBox(height: 6),
      const Text('Start a swap to begin chatting!', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
    ]));
  }
}
