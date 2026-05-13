import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/swap_request_model.dart';
import '../../models/user_model.dart';
import '../../repositories/firestore_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class SwapRequestScreen extends ConsumerStatefulWidget {
  final String userId;
  const SwapRequestScreen({super.key, required this.userId});

  @override
  ConsumerState<SwapRequestScreen> createState() => _SwapRequestScreenState();
}

class _SwapRequestScreenState extends ConsumerState<SwapRequestScreen> {
  String? _skillOffered;
  String? _skillRequested;
  int _credits = 1;
  final _msgCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }

  Future<void> _sendRequest(UserModel toUser) async {
    if (_skillOffered == null || _skillRequested == null) return;
    setState(() => _isLoading = true);
    try {
      final me = ref.read(authStateProvider).valueOrNull;
      if (me == null) return;
      final myUser = ref.read(currentUserModelProvider).valueOrNull;
      final request = SwapRequestModel(
        id: '', fromUserId: me.uid, fromUserName: myUser?.name ?? me.displayName ?? 'User',
        toUserId: toUser.uid, toUserName: toUser.name,
        skillOffered: _skillOffered!, skillRequested: _skillRequested!,
        timeCredits: _credits, message: _msgCtrl.text.trim().isNotEmpty ? _msgCtrl.text.trim() : null,
        createdAt: DateTime.now(),
      );
      await ref.read(firestoreRepositoryProvider).createSwapRequest(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Swap request sent to ${toUser.name}!'), backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final toUserAsync = ref.watch(userByIdProvider(widget.userId));

    return toUserAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (toUser) {
        if (toUser == null) return const Scaffold(body: Center(child: Text('User not found')));
        final myUser = ref.watch(currentUserModelProvider).valueOrNull;

        return Scaffold(
          appBar: AppBar(title: Text('Swap with ${toUser.name}'), backgroundColor: AppColors.bgSecondary, elevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // User card
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  CircleAvatar(radius: 28, backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(toUser.avatarInitials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18))),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(toUser.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Row(children: [Icon(Icons.star, size: 14, color: AppColors.yellow), const SizedBox(width: 4),
                      Text(toUser.ratingDisplay, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))]),
                  ])),
                ])),
              const SizedBox(height: 24),

              // Skill I offer
              const Text('Skill You\'ll Teach', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8,
                children: (myUser?.skillsOffered ?? []).map((s) => GestureDetector(
                  onTap: () => setState(() => _skillOffered = s),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: _skillOffered == s ? AppColors.primary : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10), border: Border.all(color: _skillOffered == s ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3))),
                    child: Text(s, style: TextStyle(fontSize: 13, color: _skillOffered == s ? Colors.white : AppColors.primary, fontWeight: FontWeight.w500)),
                  ),
                )).toList()),
              const SizedBox(height: 20),

              // Skill I want
              const Text('Skill You\'ll Learn', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.purple)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8,
                children: toUser.skillsOffered.map((s) => GestureDetector(
                  onTap: () => setState(() => _skillRequested = s),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: _skillRequested == s ? AppColors.purple : AppColors.purple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10), border: Border.all(color: _skillRequested == s ? AppColors.purple : AppColors.purple.withValues(alpha: 0.3))),
                    child: Text(s, style: TextStyle(fontSize: 13, color: _skillRequested == s ? Colors.white : AppColors.purple, fontWeight: FontWeight.w500)),
                  ),
                )).toList()),
              const SizedBox(height: 20),

              // Credits
              const Text('Time Credits', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Row(children: [
                IconButton(onPressed: () { if (_credits > 1) setState(() => _credits--); },
                  icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.remove, color: AppColors.textSecondary, size: 18))),
                Container(width: 60, padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text('$_credits', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)))),
                IconButton(onPressed: () { if (_credits < 10) setState(() => _credits++); },
                  icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add, color: AppColors.textSecondary, size: 18))),
                const SizedBox(width: 8),
                Text('hours', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 20),

              // Message
              const Text('Message (optional)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              TextField(controller: _msgCtrl, maxLines: 3, style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(hintText: 'Say hello and describe what you want to learn...')),
              const SizedBox(height: 28),

              // Send button
              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _skillOffered != null && _skillRequested != null && !_isLoading ? () => _sendRequest(toUser) : null,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.textMuted, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                  child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Send Swap Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                )),
            ]),
          ),
        );
      },
    );
  }
}
