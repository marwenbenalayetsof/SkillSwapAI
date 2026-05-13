import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/review_model.dart';
import '../../repositories/firestore_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class CreateReviewScreen extends ConsumerStatefulWidget {
  final String swapRequestId;
  final String toUserId;
  final String toUserName;
  const CreateReviewScreen({super.key, required this.swapRequestId, required this.toUserId, required this.toUserName});

  @override
  ConsumerState<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends ConsumerState<CreateReviewScreen> {
  int _rating = 5;
  final _commentCtrl = TextEditingController();
  final List<String> _selectedTags = [];
  bool _isLoading = false;
  static const _availableTags = ['patient', 'knowledgeable', 'on_time', 'clear_teacher', 'creative', 'helpful', 'professional'];

  @override
  void dispose() { _commentCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      final me = ref.read(authStateProvider).valueOrNull;
      final myUser = ref.read(currentUserModelProvider).valueOrNull;
      if (me == null) return;
      final review = ReviewModel(
        id: '', fromUserId: me.uid, fromUserName: myUser?.name ?? 'User',
        toUserId: widget.toUserId, toUserName: widget.toUserName,
        swapRequestId: widget.swapRequestId, rating: _rating,
        comment: _commentCtrl.text.trim().isNotEmpty ? _commentCtrl.text.trim() : null,
        tags: _selectedTags, createdAt: DateTime.now(),
      );
      await ref.read(firestoreRepositoryProvider).createReview(review);
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write Review'), backgroundColor: AppColors.bgSecondary, elevation: 0),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Rate ${widget.toUserName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) =>
            GestureDetector(onTap: () => setState(() => _rating = i + 1),
              child: Icon(i < _rating ? Icons.star_rounded : Icons.star_border_rounded, size: 44, color: AppColors.yellow)))),
          const SizedBox(height: 20),
          const Text('Tags', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((t) {
              final isSelected = _selectedTags.contains(t);
              return GestureDetector(
                onTap: () => setState(() => isSelected ? _selectedTags.remove(t) : _selectedTags.add(t)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(t, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.primary, fontWeight: FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Comment (optional)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          TextField(controller: _commentCtrl, maxLines: 3, style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(hintText: 'Share your experience...')),
          const SizedBox(height: 28),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
            child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Submit Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          )),
        ])),
    );
  }
}
