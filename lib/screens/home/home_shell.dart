import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../repositories/firestore_repository.dart';

class HomeShell extends ConsumerStatefulWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _currentIndex() {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/browse')) return 1;
    if (location.startsWith('/ai')) return 2;
    if (location.startsWith('/chats')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(int index) {
    switch (index) {
      case 0: context.go('/home');
      case 1: context.go('/browse');
      case 2: context.go('/ai');
      case 3: context.go('/chats');
      case 4: context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fsAvailable = FirestoreRepository.isAvailable;
    return Scaffold(
      body: Column(children: [
        if (!fsAvailable)
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.15), border: Border(bottom: BorderSide(color: Colors.orange.withValues(alpha: 0.3)))),
            child: Row(children: [
              const Icon(Icons.info_outline, color: Colors.orange, size: 14),
              const SizedBox(width: 6),
              Expanded(child: Text('Demo Mode — Enable Firestore for full experience', style: TextStyle(color: Colors.orange.shade200, fontSize: 11))),
            ])),
        Expanded(child: widget.child),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, -2))],
          border: Border(top: BorderSide(color: AppColors.textMuted.withValues(alpha: 0.1)))),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _navItem(Icons.home_rounded, 'Home', 0),
            _navItem(Icons.explore_rounded, 'Browse', 1),
            _navItem(Icons.auto_awesome, 'AI', 2),
            _navItem(Icons.chat_bubble_outline, 'Chat', 3),
            _navItem(Icons.person_outline, 'Profile', 4),
          ]),
        )),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = _currentIndex() == index;
    return GestureDetector(
      onTap: () => _onTap(index),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(color: selected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.textMuted, size: 22),
          if (selected) ...[const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600))],
        ]),
      ),
    );
  }
}
