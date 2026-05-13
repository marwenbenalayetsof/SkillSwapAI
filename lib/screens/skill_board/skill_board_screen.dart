import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../providers/community_provider.dart';

class SkillBoardScreen extends ConsumerWidget {
  const SkillBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(skillBoardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Board'), backgroundColor: AppColors.bgSecondary, elevation: 0),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const Center(child: Text('Could not load board')),
        data: (posts) {
          if (posts.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.forum_outlined, color: AppColors.textMuted, size: 48), const SizedBox(height: 12),
            const Text('No posts yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ]));
          return ListView.separated(padding: const EdgeInsets.all(16), itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final p = posts[i];
              final isOffer = p.type == 'offer';
              final color = isOffer ? AppColors.primary : AppColors.purple;
              return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.2))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                      child: Text(isOffer ? 'OFFER' : 'REQUEST', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 8),
                    Text(p.userName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const Spacer(),
                    Text(p.createdAt.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ]),
                  const SizedBox(height: 8),
                  Text(p.skill, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
                  if (p.description != null) ...[const SizedBox(height: 4),
                    Text(p.description!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))],
                  if (p.tags.isNotEmpty) ...[const SizedBox(height: 8),
                    Wrap(spacing: 4, runSpacing: 4, children: p.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text('#$t', style: TextStyle(fontSize: 10, color: color)),
                    )).toList())],
                ]));
            });
        },
      ),
    );
  }
}
