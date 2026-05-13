import '../models/user_model.dart';
import '../models/swap_request_model.dart';
import '../models/skill_board_model.dart';
import '../models/group_session_model.dart';
import '../models/review_model.dart';

class DemoDataService {
  static final List<UserModel> demoUsers = [
    UserModel(uid: 'demo1', name: 'Sarah Chen', email: 'sarah@demo.com', bio: 'UI/UX Designer with 5 years of experience in fintech', location: 'San Francisco', skillsOffered: ['UI/UX Design', 'Figma', 'Adobe XD'], skillsWanted: ['Python', 'Machine Learning'], timeCredits: 12, rating: 4.8, reviewCount: 15, completedSwaps: 22, badges: ['top_mentor', 'five_star'], createdAt: DateTime.now().subtract(const Duration(days: 90))),
    UserModel(uid: 'demo2', name: 'Alex Rivera', email: 'alex@demo.com', bio: 'Full-stack Python developer, Django specialist', location: 'Berlin', skillsOffered: ['Python', 'Django', 'PostgreSQL'], skillsWanted: ['React', 'TypeScript'], timeCredits: 8, rating: 4.5, reviewCount: 10, completedSwaps: 15, badges: ['fast_responder'], createdAt: DateTime.now().subtract(const Duration(days: 75))),
    UserModel(uid: 'demo3', name: 'Priya Sharma', email: 'priya@demo.com', bio: 'Mobile developer passionate about Flutter & Firebase', location: 'Mumbai', skillsOffered: ['Flutter', 'Dart', 'Firebase'], skillsWanted: ['AWS', 'Docker'], timeCredits: 15, rating: 4.9, reviewCount: 20, completedSwaps: 30, badges: ['top_mentor', 'five_star', 'skill_master'], createdAt: DateTime.now().subtract(const Duration(days: 60))),
    UserModel(uid: 'demo4', name: 'Marcus Johnson', email: 'marcus@demo.com', bio: 'Cloud architect & DevOps engineer', location: 'London', skillsOffered: ['AWS', 'Terraform', 'Kubernetes'], skillsWanted: ['Flutter', 'UI Design'], timeCredits: 20, rating: 4.3, reviewCount: 8, completedSwaps: 12, badges: ['community_builder'], createdAt: DateTime.now().subtract(const Duration(days: 45))),
    UserModel(uid: 'demo5', name: 'Yuki Tanaka', email: 'yuki@demo.com', bio: 'ML researcher transitioning to industry', location: 'Tokyo', skillsOffered: ['Machine Learning', 'TensorFlow', 'Python'], skillsWanted: ['Web Development', 'JavaScript'], timeCredits: 6, rating: 4.7, reviewCount: 12, completedSwaps: 18, badges: ['five_star', 'skill_master'], createdAt: DateTime.now().subtract(const Duration(days: 30))),
    UserModel(uid: 'demo6', name: 'Emma Laurent', email: 'emma@demo.com', bio: 'Frontend developer who loves React and design systems', location: 'Paris', skillsOffered: ['React', 'Node.js', 'CSS'], skillsWanted: ['Data Science', 'Python'], timeCredits: 10, rating: 4.6, reviewCount: 14, completedSwaps: 20, badges: ['fast_responder', 'community_builder'], createdAt: DateTime.now().subtract(const Duration(days: 20))),
    UserModel(uid: 'demo7', name: 'Omar Hassan', email: 'omar@demo.com', bio: 'DevOps specialist, Docker and CI/CD expert', location: 'Dubai', skillsOffered: ['Docker', 'CI/CD', 'Linux', 'Git'], skillsWanted: ['Machine Learning', 'Python'], timeCredits: 14, rating: 4.4, reviewCount: 9, completedSwaps: 13, badges: ['early_adopter'], createdAt: DateTime.now().subtract(const Duration(days: 15))),
    UserModel(uid: 'demo8', name: 'Lisa Wang', email: 'lisa@demo.com', bio: 'Data scientist who wants to build mobile apps', location: 'Singapore', skillsOffered: ['Data Science', 'Python', 'SQL'], skillsWanted: ['Flutter', 'Dart'], timeCredits: 7, rating: 4.8, reviewCount: 11, completedSwaps: 16, badges: ['five_star'], createdAt: DateTime.now().subtract(const Duration(days: 10))),
  ];

  static final List<SwapRequestModel> demoSwaps = [
    SwapRequestModel(id: 'ds1', fromUserId: 'demo2', fromUserName: 'Alex Rivera', toUserId: 'demo1', toUserName: 'Sarah Chen', skillOffered: 'Python', skillRequested: 'UI/UX Design', status: 'pending', timeCredits: 2, message: 'I would love to learn UI design basics!', createdAt: DateTime.now().subtract(const Duration(hours: 3))),
    SwapRequestModel(id: 'ds2', fromUserId: 'demo4', fromUserName: 'Marcus Johnson', toUserId: 'demo3', toUserName: 'Priya Sharma', skillOffered: 'AWS', skillRequested: 'Flutter', status: 'accepted', timeCredits: 3, message: 'Let me teach you cloud deployment!', createdAt: DateTime.now().subtract(const Duration(days: 1))),
    SwapRequestModel(id: 'ds3', fromUserId: 'demo5', fromUserName: 'Yuki Tanaka', toUserId: 'demo6', toUserName: 'Emma Laurent', skillOffered: 'Machine Learning', skillRequested: 'React', status: 'completed', timeCredits: 2, createdAt: DateTime.now().subtract(const Duration(days: 7))),
  ];

  static final List<SkillBoardModel> demoBoardPosts = [
    SkillBoardModel(id: 'db1', userId: 'demo1', userName: 'Sarah Chen', type: 'offer', skill: 'UI/UX Design', description: 'Free 1-hour design consultation for your app', tags: ['design', 'free'], createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    SkillBoardModel(id: 'db2', userId: 'demo5', userName: 'Yuki Tanaka', type: 'request', skill: 'JavaScript', description: 'Looking for a JavaScript mentor', tags: ['javascript', 'web'], createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    SkillBoardModel(id: 'db3', userId: 'demo3', userName: 'Priya Sharma', type: 'offer', skill: 'Flutter', description: 'Can teach Flutter basics and help build your first app', tags: ['flutter', 'mobile'], createdAt: DateTime.now().subtract(const Duration(days: 1))),
  ];

  static final List<GroupSessionModel> demoSessions = [
    GroupSessionModel(id: 'gs1', hostId: 'demo5', hostName: 'Yuki Tanaka', title: 'ML Basics Workshop', description: 'Intro to ML with Python and TensorFlow', skill: 'Machine Learning', maxParticipants: 5, participantIds: ['demo2', 'demo6'], participantNames: ['Alex Rivera', 'Emma Laurent'], creditsPerParticipant: 2, scheduledAt: DateTime.now().add(const Duration(days: 3)), durationMinutes: 90, status: 'upcoming', createdAt: DateTime.now().subtract(const Duration(days: 2))),
    GroupSessionModel(id: 'gs2', hostId: 'demo3', hostName: 'Priya Sharma', title: 'Build Your First Flutter App', description: 'Step-by-step guide to Flutter development', skill: 'Flutter', maxParticipants: 8, participantIds: ['demo4'], participantNames: ['Marcus Johnson'], creditsPerParticipant: 1, scheduledAt: DateTime.now().add(const Duration(days: 7)), durationMinutes: 120, status: 'upcoming', createdAt: DateTime.now().subtract(const Duration(days: 1))),
  ];

  static final List<ReviewModel> demoReviews = [
    ReviewModel(id: 'dr1', fromUserId: 'demo6', fromUserName: 'Emma Laurent', toUserId: 'demo5', toUserName: 'Yuki Tanaka', swapRequestId: 'ds3', rating: 5, comment: 'Yuki is an amazing ML teacher! Very patient and knowledgeable.', tags: ['patient', 'knowledgeable'], createdAt: DateTime.now().subtract(const Duration(days: 5))),
    ReviewModel(id: 'dr2', fromUserId: 'demo5', fromUserName: 'Yuki Tanaka', toUserId: 'demo6', toUserName: 'Emma Laurent', swapRequestId: 'ds3', rating: 5, comment: 'Emma explained React concepts really clearly.', tags: ['clear_teacher', 'on_time'], createdAt: DateTime.now().subtract(const Duration(days: 5))),
    ReviewModel(id: 'dr3', fromUserId: 'demo2', fromUserName: 'Alex Rivera', toUserId: 'demo1', toUserName: 'Sarah Chen', swapRequestId: 'ds1', rating: 4, comment: 'Great design tips! Very creative approach.', tags: ['creative', 'helpful'], createdAt: DateTime.now().subtract(const Duration(days: 1))),
  ];
}
