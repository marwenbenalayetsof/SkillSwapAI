import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/firestore_repository.dart';
import '../services/demo_data_service.dart';
import 'auth_provider.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) => FirestoreRepository());

final currentUserModelProvider = StreamProvider<UserModel?>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(null);
  if (!FirestoreRepository.isAvailable) {
    return Stream.value(DemoDataService.demoUsers.where((u) => u.uid == user.uid).firstOrNull);
  }
  return ref.read(firestoreRepositoryProvider).getUserStream(user.uid);
});

final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  if (!FirestoreRepository.isAvailable) return Stream.value(DemoDataService.demoUsers);
  return ref.read(firestoreRepositoryProvider).getAllUsers();
});

final otherUsersProvider = Provider<List<UserModel>>((ref) {
  final currentUser = ref.watch(authStateProvider).valueOrNull;
  final users = ref.watch(allUsersProvider).valueOrNull ?? [];
  return users.where((u) => u.uid != currentUser?.uid).toList();
});

final userByIdProvider = FutureProvider.family<UserModel?, String>((ref, uid) async {
  if (!FirestoreRepository.isAvailable) {
    return DemoDataService.demoUsers.where((u) => u.uid == uid).firstOrNull;
  }
  return ref.read(firestoreRepositoryProvider).getUser(uid);
});
