import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';
import '../models/review_model.dart';
import '../repositories/firestore_repository.dart';
import '../services/demo_data_service.dart';

final userReviewsProvider = StreamProvider.family<List<ReviewModel>, String>((ref, userId) {
  if (!FirestoreRepository.isAvailable) return Stream.value(DemoDataService.demoReviews.where((r) => r.toUserId == userId).toList());
  return ref.read(firestoreRepositoryProvider).getUserReviews(userId);
});
