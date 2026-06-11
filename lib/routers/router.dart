import 'package:go_router/go_router.dart';
import 'package:i_bazaar/screens/auth/register_screen.dart';
import 'package:i_bazaar/screens/main/adspace_screen.dart';
import 'package:i_bazaar/screens/main/chat_detail_screen.dart';
import 'package:i_bazaar/screens/main/chat_screen.dart';
import 'package:i_bazaar/screens/main/home_screen.dart';
import 'package:i_bazaar/screens/auth/login_screen.dart';
import 'package:i_bazaar/screens/main/listings_screen.dart';
import 'package:i_bazaar/screens/main/main_screen.dart';
import 'package:i_bazaar/screens/main/profile_screen.dart';
import 'package:i_bazaar/screens/main/search_screen.dart';

final router = GoRouter(
  initialLocation: "/home",
  routes: [
    GoRoute(path: "/login", builder: (_, __) => LoginScreen()),
    GoRoute(path: "/register", builder: (_, __) => RegisterScreen()),
    GoRoute(path: "/adspace", builder: (_, __) => const AdspaceScreen()),

    GoRoute(
      path: "/chat/:conversationId",
      builder: (_, state) => ChatDetailScreen(
        conversationId: state.pathParameters['conversationId']!,
      ),
    ),

    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(path: "/home", builder:  (_, __) => HomeScreen()),
        GoRoute(path: "/search", builder:  (_, __) => SearchScreen()),
        GoRoute(path: "/chat", builder: (_, __) => ChatScreen()),
        GoRoute(path: "/listings", builder: (_, __) => ListingsScreen()),
        GoRoute(path: "/profile", builder: (_, __) => ProfileScreen()),
    ])
  ]
);
