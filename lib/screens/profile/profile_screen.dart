import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../core/constants/app_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(currentUserModelProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar & Name
              Center(
                child: Column(children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 6))],
                    ),
                    child: Center(child: Text(userModel?.avatarInitials ?? '?',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
                  ),
                  const SizedBox(height: 14),
                  Text(userModel?.name ?? 'User', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  if (userModel?.bio != null) ...[
                    const SizedBox(height: 6),
                    Text(userModel!.bio!, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                  if (userModel?.location != null) ...[
                    const SizedBox(height: 4),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
                      Text(userModel!.location!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                    ]),
                  ],
                ]),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(children: [
                _profileStat('Credits', '${userModel?.timeCredits ?? 0}', AppColors.primary),
                _profileStat('Swaps', '${userModel?.completedSwaps ?? 0}', AppColors.purple),
                _profileStat('Rating', userModel?.ratingDisplay ?? 'New', AppColors.yellow),
                _profileStat('Reviews', '${userModel?.reviewCount ?? 0}', AppColors.blue),
              ]),
              const SizedBox(height: 24),

              // Badges
              if (userModel?.badges.isNotEmpty == true) ...[
                const Align(alignment: Alignment.centerLeft,
                  child: Text('Badges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8,
                  children: userModel!.badges.map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.yellow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(_badgeEmoji(b), style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(_badgeLabel(b), style: const TextStyle(fontSize: 12, color: AppColors.yellow, fontWeight: FontWeight.w600)),
                    ]),
                  )).toList()),
                const SizedBox(height: 24),
              ],

              // Skills Offered
              const Align(alignment: Alignment.centerLeft,
                child: Text('Skills I Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8,
                children: (userModel?.skillsOffered ?? []).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))),
                  child: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                )).toList()),
              const SizedBox(height: 20),

              // Skills Wanted
              const Align(alignment: Alignment.centerLeft,
                child: Text('Skills I Want', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8,
                children: (userModel?.skillsWanted ?? []).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.purple.withValues(alpha: 0.3))),
                  child: Text(s, style: TextStyle(fontSize: 13, color: AppColors.purple, fontWeight: FontWeight.w500)),
                )).toList()),
              const SizedBox(height: 30),

              // Actions
              _menuTile('My Swaps', Icons.swap_horiz, AppColors.primary, () => context.go('/swaps')),
              _menuTile('Leaderboard', Icons.emoji_events, AppColors.yellow, () => context.go('/leaderboard')),
              _menuTile('Settings', Icons.settings, AppColors.textMuted, () => context.go('/settings')),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).signOut();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileStat(String label, String value, Color color) {
    return Expanded(
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2))),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
    );
  }

  Widget _menuTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          const Spacer(),
          Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ])),
    );
  }

  String _badgeEmoji(String badge) {
    switch (badge) {
      case AppConstants.badgeTopMentor: return '🏆';
      case AppConstants.badgeFastResponder: return '⚡';
      case AppConstants.badgeFiveStar: return '⭐';
      case AppConstants.badgeEarlyAdopter: return '🚀';
      case AppConstants.badgeSkillMaster: return '🎯';
      case AppConstants.badgeCommunityBuilder: return '🤝';
      default: return '🏅';
    }
  }

  String _badgeLabel(String badge) {
    switch (badge) {
      case AppConstants.badgeTopMentor: return 'Top Mentor';
      case AppConstants.badgeFastResponder: return 'Fast Responder';
      case AppConstants.badgeFiveStar: return '5-Star';
      case AppConstants.badgeEarlyAdopter: return 'Early Adopter';
      case AppConstants.badgeSkillMaster: return 'Skill Master';
      case AppConstants.badgeCommunityBuilder: return 'Community Builder';
      default: return badge;
    }
  }
}
