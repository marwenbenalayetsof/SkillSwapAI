import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(otherUsersProvider);
    final sorted = List<UserModel>.from(users)..sort((a, b) => b.completedSwaps.compareTo(a.completedSwaps));

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard'), backgroundColor: AppColors.bgSecondary, elevation: 0),
      body: sorted.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.emoji_events_outlined, color: AppColors.textMuted, size: 48),
        const SizedBox(height: 12), const Text('No users yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ])) : ListView.separated(padding: const EdgeInsets.all(16), itemCount: sorted.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final u = sorted[i];
          final medal = i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : '${i + 1}';
          return GestureDetector(
            onTap: () => context.go('/swap-request/${u.uid}'),
            child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                SizedBox(width: 40, child: Text(medal, style: TextStyle(fontSize: i < 3 ? 24 : 16), textAlign: TextAlign.center)),
                const SizedBox(width: 12),
                CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(u.avatarInitials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('${u.completedSwaps} swaps completed', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: [Icon(Icons.star, size: 14, color: AppColors.yellow), const SizedBox(width: 4),
                    Text(u.ratingDisplay, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
                  Text('${u.timeCredits} credits', style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                ]),
              ])),
          );
        }),
    );
  }
}
