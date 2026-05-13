import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../models/swap_request_model.dart';
import 'user_provider.dart';
import '../repositories/firestore_repository.dart';
import 'user_provider.dart';
import '../services/demo_data_service.dart';
import 'user_provider.dart';
import 'auth_provider.dart';
import 'user_provider.dart';

final mySwapsProvider = StreamProvider<List<SwapRequestModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  if (!FirestoreRepository.isAvailable) {
    return Stream.value(DemoDataService.demoSwaps.where((s) => s.fromUserId == user.uid || s.toUserId == user.uid).toList());
  }
  return ref.read(firestoreRepositoryProvider).getSwapRequests(user.uid);
});

final incomingSwapsProvider = Provider<List<SwapRequestModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return (ref.watch(mySwapsProvider).valueOrNull ?? []).where((s) => s.toUserId == user?.uid && s.isPending).toList();
});

final outgoingSwapsProvider = Provider<List<SwapRequestModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return (ref.watch(mySwapsProvider).valueOrNull ?? []).where((s) => s.fromUserId == user?.uid).toList();
});
