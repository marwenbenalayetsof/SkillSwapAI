import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/auth_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/home/home_screen.dart';
import 'screens/browse/browse_screen.dart';
import 'screens/ai/ai_matches_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_room_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/swap/swap_request_screen.dart';
import 'screens/swap/my_swaps_screen.dart';
import 'screens/reviews/review_screen.dart';
import 'screens/reviews/create_review_screen.dart';
import 'screens/leaderboard/leaderboard_screen.dart';
import 'screens/skill_board/skill_board_screen.dart';
import 'screens/sessions/group_sessions_screen.dart';
import 'screens/settings/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/browse', builder: (_, __) => const BrowseScreen()),
          GoRoute(path: '/ai', builder: (_, __) => const AIMatchesScreen()),
          GoRoute(path: '/chats', builder: (_, __) => const ChatListScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/swaps', builder: (_, __) => const MySwapsScreen()),
          GoRoute(path: '/leaderboard', builder: (_, __) => const LeaderboardScreen()),
          GoRoute(path: '/board', builder: (_, __) => const SkillBoardScreen()),
          GoRoute(path: '/sessions', builder: (_, __) => const GroupSessionsScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
      GoRoute(path: '/chat/:roomId', builder: (_, state) => ChatRoomScreen(roomId: state.pathParameters['roomId']!)),
      GoRoute(path: '/swap-request/:userId', builder: (_, state) => SwapRequestScreen(userId: state.pathParameters['userId']!)),
      GoRoute(path: '/reviews/:userId', builder: (_, state) => ReviewScreen(userId: state.pathParameters['userId']!)),
      GoRoute(path: '/create-review/:swapId/:toUserId', builder: (_, state) {
        final parts = state.pathParameters['toUserId']!.split('&');
        return CreateReviewScreen(swapRequestId: state.pathParameters['swapId']!, toUserId: parts[0], toUserName: parts.length > 1 ? parts[1] : 'User');
      }),
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register';
      final isSplashRoute = state.uri.path == '/splash';

      // Don't redirect from splash - it handles its own navigation
      if (isSplashRoute) return null;

      // If not authenticated and trying to access protected route, go to login
      if (user == null && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and on auth routes, go to home
      if (user != null && isAuthRoute) {
        return '/home';
      }

      return null;
    },
  );
}
