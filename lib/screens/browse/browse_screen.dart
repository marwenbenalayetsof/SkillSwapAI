import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});
  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  String _search = '';
  String _filterCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(otherUsersProvider);
    final filtered = _filterUsers(users);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: AppColors.bgSecondary,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            onChanged: (v) => setState(() => _search = v),
                            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search skills or names...',
                              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                              prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', ...AppConstants.skillCategories.keys].map((cat) {
                        final selected = _filterCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _filterCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.bgInput,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: selected ? AppColors.primary : AppColors.textMuted.withValues(alpha: 0.2)),
                            ),
                            child: Text(cat, style: TextStyle(
                              color: selected ? AppColors.primary : AppColors.textSecondary,
                              fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Users Grid
            Expanded(
              child: filtered.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.people_outline, color: AppColors.textMuted, size: 48),
                    const SizedBox(height: 12),
                    const Text('No users found', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ]))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _userCard(filtered[i]),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  List<UserModel> _filterUsers(List<UserModel> users) {
    var result = users;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result.where((u) =>
        u.name.toLowerCase().contains(q) ||
        u.skillsOffered.any((s) => s.toLowerCase().contains(q)) ||
        u.skillsWanted.any((s) => s.toLowerCase().contains(q))
      ).toList();
    }
    if (_filterCategory != 'All') {
      final catSkills = AppConstants.skillCategories[_filterCategory] ?? [];
      result = result.where((u) =>
        u.skillsOffered.any((s) => catSkills.any((cs) => cs.toLowerCase() == s.toLowerCase())) ||
        u.skillsWanted.any((s) => catSkills.any((cs) => cs.toLowerCase() == s.toLowerCase()))
      ).toList();
    }
    return result;
  }

  Widget _userCard(UserModel user) {
    return GestureDetector(
      onTap: () => context.go('/swap-request/${user.uid}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 22, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(user.avatarInitials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (user.location != null)
                      Row(children: [
                        Icon(Icons.location_on, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 2),
                        Text(user.location!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ]),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.star, size: 14, color: AppColors.yellow),
              const SizedBox(width: 4),
              Text(user.ratingDisplay, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(width: 8),
              Icon(Icons.swap_horiz, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 2),
              Text('${user.completedSwaps}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text('${user.timeCredits} credits', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600))),
            ]),
            const Divider(height: 16),
            Text('Offers', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 4),
            Wrap(spacing: 4, runSpacing: 4,
              children: user.skillsOffered.take(3).map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                child: Text(s, style: TextStyle(fontSize: 10, color: AppColors.primary)),
              )).toList()),
            if (user.skillsOffered.length > 3) Padding(padding: const EdgeInsets.only(top: 2),
              child: Text('+${user.skillsOffered.length - 3} more', style: const TextStyle(fontSize: 10, color: AppColors.textMuted))),
            const SizedBox(height: 6),
            Text('Wants', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.purple)),
            const SizedBox(height: 4),
            Wrap(spacing: 4, runSpacing: 4,
              children: user.skillsWanted.take(3).map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.purple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                child: Text(s, style: TextStyle(fontSize: 10, color: AppColors.purple)),
              )).toList()),
          ],
        ),
      ),
    );
  }
}
