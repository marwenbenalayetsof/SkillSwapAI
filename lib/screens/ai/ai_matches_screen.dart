import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/ai_provider.dart';

class AIMatchesScreen extends ConsumerWidget {
  const AIMatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(aiMatchesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: AppColors.bgSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(gradient: AppColors.sunsetGradient, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22)),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('AI Skill Matching', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      Text('Find your perfect swap partner', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ])),
                  ]),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2))),
                    child: Row(children: [
                      Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text('AI analyzes your skills to find the best complementary matches for mutual learning.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                    ])),
                ],
              ),
            ),
            Expanded(
              child: matchesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: AppColors.textSecondary))),
                data: (matches) {
                  if (matches.isEmpty) {
                    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.search_off, color: AppColors.textMuted, size: 48),
                      const SizedBox(height: 12),
                      const Text('No matches yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      const SizedBox(height: 6),
                      const Text('Add more skills to improve matching', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    ]));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: matches.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final user = matches[i].$1;
                      final score = matches[i].$2;
                      return _matchCard(context, user, score);
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

  Widget _matchCard(BuildContext context, UserModel user, double score) {
    final matchPercent = (score * 100).round();
    final color = matchPercent >= 70 ? AppColors.success : matchPercent >= 40 ? AppColors.warning : AppColors.textMuted;

    return GestureDetector(
      onTap: () => context.go('/swap-request/${user.uid}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 26, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(user.avatarInitials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    if (user.bio != null)
                      Text(user.bio!, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                ),
                Column(children: [
                  Text('$matchPercent%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
                  const Text('match', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ]),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Can teach you', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Wrap(spacing: 4, runSpacing: 4,
                      children: user.skillsOffered.take(4).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                        child: Text(s, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                      )).toList()),
                  ]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Wants to learn', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.purple)),
                    const SizedBox(height: 4),
                    Wrap(spacing: 4, runSpacing: 4,
                      children: user.skillsWanted.take(4).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.purple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                        child: Text(s, style: TextStyle(fontSize: 10, color: AppColors.purple)),
                      )).toList()),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              Icon(Icons.star, size: 14, color: AppColors.yellow),
              const SizedBox(width: 4),
              Text(user.ratingDisplay, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Icon(Icons.swap_horiz, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${user.completedSwaps} swaps', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: const Text('Request Swap', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white))),
            ]),
          ],
        ),
      ),
    );
  }
}
