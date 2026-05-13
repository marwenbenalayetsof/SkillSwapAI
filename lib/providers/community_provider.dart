import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../models/skill_board_model.dart';
import '../models/group_session_model.dart';
import '../repositories/firestore_repository.dart';
import '../services/demo_data_service.dart';

final skillBoardProvider = StreamProvider<List<SkillBoardModel>>((ref) {
  if (!FirestoreRepository.isAvailable) return Stream.value(DemoDataService.demoBoardPosts);
  return ref.read(firestoreRepositoryProvider).getBoardPosts();
});

final groupSessionsProvider = StreamProvider<List<GroupSessionModel>>((ref) {
  if (!FirestoreRepository.isAvailable) return Stream.value(DemoDataService.demoSessions);
  return ref.read(firestoreRepositoryProvider).getGroupSessions();
});
