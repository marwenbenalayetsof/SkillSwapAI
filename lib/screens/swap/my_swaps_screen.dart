import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../providers/user_provider.dart';
import '../../providers/swap_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../repositories/firestore_repository.dart';
import '../../providers/user_provider.dart';
import '../../models/swap_request_model.dart';
import '../../providers/user_provider.dart';

class MySwapsScreen extends ConsumerWidget {
  const MySwapsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incoming = ref.watch(incomingSwapsProvider);
    final outgoing = ref.watch(outgoingSwapsProvider);
    final userId = ref.watch(authStateProvider).valueOrNull?.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Swaps'),
          backgroundColor: AppColors.bgSecondary, elevation: 0,
          bottom: const TabBar(
            tabs: [Tab(text: 'Incoming'), Tab(text: 'Outgoing')],
            labelColor: AppColors.primary, unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _swapList(incoming, userId, true, ref),
            _swapList(outgoing, userId, false, ref),
          ],
        ),
      ),
    );
  }

  Widget _swapList(List<SwapRequestModel> swaps, String? userId, bool isIncoming, WidgetRef ref) {
    if (swaps.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.swap_horiz, color: AppColors.textMuted, size: 48),
      const SizedBox(height: 12),
      Text(isIncoming ? 'No incoming requests' : 'No outgoing requests',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
    ]));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: swaps.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _swapCard(swaps[i], userId, isIncoming, ref),
    );
  }

  Widget _swapCard(SwapRequestModel swap, String? userId, bool isIncoming, WidgetRef ref) {
    Color statusColor;
    IconData statusIcon;
    switch (swap.status) {
      case 'pending': statusColor = AppColors.warning; statusIcon = Icons.schedule; break;
      case 'accepted': statusColor = AppColors.success; statusIcon = Icons.check_circle; break;
      case 'completed': statusColor = AppColors.primary; statusIcon = Icons.done_all; break;
      case 'rejected': statusColor = AppColors.error; statusIcon = Icons.cancel; break;
      default: statusColor = AppColors.textMuted; statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(isIncoming ? swap.fromUserName : swap.toUserName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(swap.status.toUpperCase(), style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w700)),
              ])),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Text(swap.skillOffered, style: const TextStyle(fontSize: 12, color: AppColors.primary))),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 16, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.purple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Text(swap.skillRequested, style: const TextStyle(fontSize: 12, color: AppColors.purple))),
            const Spacer(),
            Text('${swap.timeCredits} credits', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
          if (swap.message != null) ...[
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(8)),
              child: Text(swap.message!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          ],
          const SizedBox(height: 8),
          Text(swap.createdAt.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),

          // Action buttons for incoming pending swaps
          if (isIncoming && swap.isPending) ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ElevatedButton(
                onPressed: () => ref.read(firestoreRepositoryProvider).updateSwapStatus(swap.id, 'accepted'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Accept', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              )),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(
                onPressed: () => ref.read(firestoreRepositoryProvider).updateSwapStatus(swap.id, 'rejected'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Reject', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              )),
            ]),
          ],
          if (isIncoming && swap.isAccepted) ...[
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => ref.read(firestoreRepositoryProvider).updateSwapStatus(swap.id, 'completed'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)),
              child: const Text('Mark Complete', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            )),
          ],
        ],
      ),
    );
  }
}
