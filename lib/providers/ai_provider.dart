import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../core/utils/skill_matcher.dart';
import 'user_provider.dart';

final aiMatchesProvider = FutureProvider<List<(UserModel, double)>>((ref) async {
  final currentUser = ref.watch(currentUserModelProvider).valueOrNull;
  final others = ref.watch(otherUsersProvider);
  if (currentUser == null || others.isEmpty) return [];
  return SkillMatcher.getTopMatches(currentUser, others, limit: 10);
});

final skillCreditValueProvider = Provider.family<double, String>((ref, skill) {
  return SkillMatcher.calculateSkillCreditValue(skill);
});

final learningPathProvider = Provider.family<List<String>, String>((ref, targetSkill) {
  final currentUser = ref.watch(currentUserModelProvider).valueOrNull;
  if (currentUser == null) return [targetSkill];
  return SkillMatcher.suggestLearningPath([...currentUser.skillsOffered, ...currentUser.skillsWanted], targetSkill);
});
