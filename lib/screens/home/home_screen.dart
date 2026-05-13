import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../models/user_model.dart';
import '../../models/swap_request_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/swap_provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(currentUserModelProvider).valueOrNull;
    final incomingSwaps = ref.watch(incomingSwapsProvider);
    final outgoingSwaps = ref.watch(outgoingSwapsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, ${userModel?.name.split(' ').first ?? 'User'}! 👋',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Ready to swap some skills?',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/settings'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(userModel?.avatarInitials ?? '?',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  _statCard('Credits', '${userModel?.timeCredits ?? 0}', Icons.account_balance_wallet, AppColors.primary),
                  const SizedBox(width: 12),
                  _statCard('Swaps', '${userModel?.completedSwaps ?? 0}', Icons.swap_horiz, AppColors.purple),
                  const SizedBox(width: 12),
                  _statCard('Rating', userModel?.ratingDisplay ?? 'New', Icons.star, AppColors.yellow),
                ],
              ),
              const SizedBox(height: 24),

              // Pending Swaps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pending Swaps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  GestureDetector(
                    onTap: () => context.go('/swaps'),
                    child: const Text('See all', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (incomingSwaps.isEmpty && outgoingSwaps.isEmpty)
                _emptyState('No pending swaps yet', 'Browse skills to start swapping!'),
              ...incomingSwaps.take(3).map((s) => _swapCard(s, true)),
              ...outgoingSwaps.where((s) => s.isPending).take(2).map((s) => _swapCard(s, false)),

              const SizedBox(height: 24),

              // Quick Actions
              const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _actionCard('Browse\nSkills', Icons.explore_rounded, AppColors.oceanGradient, () => context.go('/browse')),
                  const SizedBox(width: 12),
                  _actionCard('AI\nMatches', Icons.auto_awesome, AppColors.sunsetGradient, () => context.go('/ai')),
                  const SizedBox(width: 12),
                  _actionCard('Community\nBoard', Icons.forum_outlined, AppColors.purpleGradient, () => context.go('/board')),
                ],
              ),
              const SizedBox(height: 24),

              // Leaderboard preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Top Swappers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  GestureDetector(
                    onTap: () => context.go('/leaderboard'),
                    child: const Text('See all', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _leaderboardPreview(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _swapCard(SwapRequestModel swap, bool isIncoming) {
    final color = isIncoming ? AppColors.primary : AppColors.purple;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(isIncoming ? Icons.call_received : Icons.call_made, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isIncoming ? swap.fromUserName : swap.toUserName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${swap.skillOffered} ↔ ${swap.skillRequested}',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Text('${swap.timeCredits} credits', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(String label, IconData icon, LinearGradient gradient, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: gradient,
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, color: AppColors.textMuted, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _leaderboardPreview(WidgetRef ref) {
    final users = ref.watch(otherUsersProvider);
    final sorted = List<UserModel>.from(users)..sort((a, b) => b.completedSwaps.compareTo(a.completedSwaps));
    final top3 = sorted.take(3).toList();
    if (top3.isEmpty) return _emptyState('No users yet', 'Be the first to join!');

    final medals = ['🥇', '🥈', '🥉'];
    return Column(
      children: top3.asMap().entries.map((e) {
        final u = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Text(medals[e.key], style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(u.avatarInitials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('${u.completedSwaps} swaps • ${u.ratingDisplay}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
