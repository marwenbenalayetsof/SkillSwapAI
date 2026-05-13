import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../repositories/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: AppColors.bgSecondary, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Appearance'),
          _tile(Icons.dark_mode, 'Dark Mode', Switch(value: themeMode == ThemeMode.dark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(), activeColor: AppColors.primary)),
          const SizedBox(height: 16),
          _section('Account'),
          _tile(Icons.person, 'Edit Profile', const Icon(Icons.chevron_right, color: AppColors.textMuted)),
          _tile(Icons.lock, 'Change Password', const Icon(Icons.chevron_right, color: AppColors.textMuted)),
          _tile(Icons.notifications, 'Notifications', Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary)),
          const SizedBox(height: 16),
          _section('About'),
          _tile(Icons.info_outline, 'App Version', const Text('2.0.0', style: TextStyle(color: AppColors.textSecondary, fontSize: 14))),
          _tile(Icons.code, 'Made with Flutter', const Icon(Icons.favorite, color: AppColors.error, size: 18)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, size: 18), label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          )),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 1.2)));
  }

  Widget _tile(IconData icon, String title, Widget trailing) {
    return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primary, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
        trailing,
      ]));
  }
}
