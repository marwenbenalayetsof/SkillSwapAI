import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../providers/review_provider.dart';

class ReviewScreen extends ConsumerWidget {
  final String userId;
  const ReviewScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(userReviewsProvider(userId));
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews'), backgroundColor: AppColors.bgSecondary, elevation: 0),
      body: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => const Center(child: Text('Could not load reviews')),
        data: (reviews) {
          if (reviews.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.rate_review_outlined, color: AppColors.textMuted, size: 48),
            const SizedBox(height: 12), const Text('No reviews yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ]));
          return ListView.separated(padding: const EdgeInsets.all(16), itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final r = reviews[i];
              return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(radius: 16, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(r.fromUserName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(r.fromUserName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                    Row(children: List.generate(5, (j) => Icon(j < r.rating ? Icons.star : Icons.star_border, size: 16, color: AppColors.yellow))),
                  ]),
                  if (r.comment != null) ...[const SizedBox(height: 8),
                    Text(r.comment!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))],
                  if (r.tags.isNotEmpty) ...[const SizedBox(height: 8),
                    Wrap(spacing: 4, runSpacing: 4, children: r.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text(t, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                    )).toList())],
                  const SizedBox(height: 6),
                  Text(r.createdAt.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ]));
            });
        },
      ),
    );
  }
}
