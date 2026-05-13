import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../providers/community_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../repositories/firestore_repository.dart';

class GroupSessionsScreen extends ConsumerWidget {
  const GroupSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(groupSessionsProvider);
    final userId = ref.watch(authStateProvider).valueOrNull?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Group Sessions'), backgroundColor: AppColors.bgSecondary, elevation: 0),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const Center(child: Text('Could not load sessions')),
        data: (sessions) {
          if (sessions.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.groups_outlined, color: AppColors.textMuted, size: 48), const SizedBox(height: 12),
            const Text('No sessions yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ]));
          return ListView.separated(padding: const EdgeInsets.all(16), itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final s = sessions[i];
              final isJoined = userId != null && s.participantIds.contains(userId);
              return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: AppColors.sunsetGradient, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.school, color: Colors.white, size: 18)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                  ]),
                  if (s.description != null) ...[const SizedBox(height: 6),
                    Text(s.description!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))],
                  const SizedBox(height: 10),
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(s.skill, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600))),
                    const SizedBox(width: 8),
                    Icon(Icons.people, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('${s.participantIds.length}/${s.maxParticipants}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('${s.durationMinutes}min', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text('By ${s.hostName}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const Spacer(),
                    Text('${s.creditsPerParticipant} credits', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ]),
                  if (!isJoined && !s.isFull && s.isUpcoming) ...[const SizedBox(height: 10),
                    SizedBox(width: double.infinity, child: ElevatedButton(
                      onPressed: () => ref.read(firestoreRepositoryProvider).joinGroupSession(s.id, userId!, 'You'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 8)),
                      child: const Text('Join Session', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ))],
                  if (isJoined) ...[const SizedBox(height: 10),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.check_circle, color: AppColors.success, size: 14), SizedBox(width: 6),
                        Text('Joined', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                      ]))],
                ]));
            });
        },
      ),
    );
  }
}
