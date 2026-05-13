import '../constants/app_constants.dart';
import '../../models/user_model.dart';

class SkillMatcher {
  /// Calculate match score between two users (0.0 to 1.0)
  /// Higher score = better match
  static double calculateMatchScore(UserModel userA, UserModel userB) {
    double score = 0.0;
    
    // What A offers matches what B wants (A can teach B)
    final aTeachesB = _intersectionCount(userA.skillsOffered, userB.skillsWanted);
    
    // What B offers matches what A wants (B can teach A)
    final bTeachesA = _intersectionCount(userB.skillsOffered, userA.skillsWanted);
    
    // Bidirectional match (best case)
    if (aTeachesB > 0 && bTeachesA > 0) {
      score += 0.5; // Bonus for bidirectional
      score += (aTeachesB + bTeachesA) * 0.15;
    } else if (aTeachesB > 0) {
      score += aTeachesB * 0.2;
    } else if (bTeachesA > 0) {
      score += bTeachesA * 0.2;
    }
    
    // Category proximity bonus
    final categoryOverlap = _categoryOverlap(userA.skillsOffered + userA.skillsWanted, 
                                               userB.skillsOffered + userB.skillsWanted);
    score += categoryOverlap * 0.1;
    
    return score.clamp(0.0, 1.0);
  }
  
  /// Get top N matches for a user from a list of candidates
  static List<(UserModel, double)> getTopMatches(
    UserModel user, 
    List<UserModel> candidates, {
    int limit = 5,
    double minScore = AppConstants.minMatchScore,
  }) {
    final scored = candidates
        .where((c) => c.uid != user.uid)
        .map((c) => (c, calculateMatchScore(user, c)))
        .where((pair) => pair.$2 >= minScore)
        .toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));
    
    return scored.take(limit).toList();
  }
  
  /// Calculate fair time credit value for a skill
  static double calculateSkillCreditValue(String skill) {
    String? category;
    for (final entry in AppConstants.skillCategories.entries) {
      if (entry.value.any((s) => s.toLowerCase() == skill.toLowerCase())) {
        category = entry.key;
        break;
      }
    }
    
    final multiplier = AppConstants.categoryCreditMultiplier[category] ?? 1.0;
    
    // Skills in fewer categories are rarer = more valuable
    // This is a simplified valuation model
    return multiplier;
  }
  
  /// Suggest a learning path from current skills to target skill
  static List<String> suggestLearningPath(
    List<String> currentSkills, 
    String targetSkill,
  ) {
    final path = <String>[];
    final targetCategory = _getCategory(targetSkill);
    
    if (targetCategory == null) return [targetSkill];
    
    // Find intermediate skills in the same category
    final categorySkills = AppConstants.skillCategories[targetCategory] ?? [];
    
    for (final skill in categorySkills) {
      if (skill.toLowerCase() == targetSkill.toLowerCase()) continue;
      if (currentSkills.any((s) => s.toLowerCase() == skill.toLowerCase())) continue;
      
      // Simple heuristic: add skills that might be prerequisites
      path.add(skill);
      if (path.length >= 3) break;
    }
    
    path.add(targetSkill);
    return path;
  }
  
  static int _intersectionCount(List<String> a, List<String> b) {
    final aLower = a.map((s) => s.toLowerCase()).toSet();
    final bLower = b.map((s) => s.toLowerCase()).toSet();
    return aLower.intersection(bLower).length;
  }
  
  static double _categoryOverlap(List<String> a, List<String> b) {
    final aCategories = a.map(_getCategory).whereType<String>().toSet();
    final bCategories = b.map(_getCategory).whereType<String>().toSet();
    if (aCategories.isEmpty || bCategories.isEmpty) return 0.0;
    return aCategories.intersection(bCategories).length / 
           aCategories.union(bCategories).length;
  }
  
  static String? _getCategory(String skill) {
    for (final entry in AppConstants.skillCategories.entries) {
      if (entry.value.any((s) => s.toLowerCase() == skill.toLowerCase())) {
        return entry.key;
      }
    }
    return null;
  }
}
