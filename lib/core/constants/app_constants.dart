class AppConstants {
  static const String appName = 'SkillSwapAI';
  static const String appTagline = 'Global Time-Banking for the AI Era';
  static const String appVersion = '2.0.0';
  
  // Collections
  static const String usersCollection = 'users';
  static const String swapRequestsCollection = 'swap_requests';
  static const String chatRoomsCollection = 'chat_rooms';
  static const String messagesCollection = 'messages';
  static const String reviewsCollection = 'reviews';
  static const String skillBoardsCollection = 'skill_boards';
  static const String groupSessionsCollection = 'group_sessions';
  static const String notificationsCollection = 'notifications';
  static const String transactionsCollection = 'transactions';
  
  // Defaults
  static const int defaultTimeCredits = 5;
  static const int maxSkillsPerUser = 10;
  static const int minPasswordLength = 6;
  static const double minMatchScore = 0.3;
  
  // Swap Status
  static const String swapPending = 'pending';
  static const String swapAccepted = 'accepted';
  static const String swapCompleted = 'completed';
  static const String swapRejected = 'rejected';
  static const String swapCancelled = 'cancelled';
  
  // Badge Types
  static const String badgeTopMentor = 'top_mentor';
  static const String badgeFastResponder = 'fast_responder';
  static const String badgeFiveStar = 'five_star';
  static const String badgeEarlyAdopter = 'early_adopter';
  static const String badgeSkillMaster = 'skill_master';
  static const String badgeCommunityBuilder = 'community_builder';
  
  // Skill categories
  static const Map<String, List<String>> skillCategories = {
    'Programming': ['Python', 'JavaScript', 'Flutter', 'React', 'Node.js', 'Java', 'C++', 'Go', 'Rust', 'TypeScript', 'Dart', 'Swift', 'Kotlin'],
    'Data & AI': ['Machine Learning', 'Data Science', 'Deep Learning', 'NLP', 'Computer Vision', 'TensorFlow', 'PyTorch', 'Statistics', 'SQL'],
    'Design': ['UI/UX Design', 'Figma', 'Adobe XD', 'Graphic Design', 'Web Design', 'Product Design', 'Motion Design'],
    'Cloud & DevOps': ['AWS', 'Azure', 'GCP', 'Docker', 'Kubernetes', 'Terraform', 'CI/CD', 'Linux', 'Git'],
    'Business': ['Marketing', 'SEO', 'Product Management', 'Project Management', 'Sales', 'Finance', 'Analytics'],
    'Languages': ['English', 'French', 'Arabic', 'Spanish', 'German', 'Chinese', 'Japanese'],
    'Creative': ['Photography', 'Video Editing', 'Music', 'Writing', 'Animation', 'Illustration'],
    'Other': ['Teaching', 'Mentoring', 'Public Speaking', 'Research', 'Consulting'],
  };
  
  // Credit values per category (base multiplier)
  static const Map<String, double> categoryCreditMultiplier = {
    'Programming': 1.2,
    'Data & AI': 1.5,
    'Design': 1.0,
    'Cloud & DevOps': 1.3,
    'Business': 1.0,
    'Languages': 0.8,
    'Creative': 0.9,
    'Other': 0.8,
  };
}
