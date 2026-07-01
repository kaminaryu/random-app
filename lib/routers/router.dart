import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/auth/register_screen.dart';
import 'package:i_bazaar/screens/main/adspace_screen.dart';
import 'package:i_bazaar/screens/main/cart/cart_screen.dart';
import 'package:i_bazaar/screens/main/chat_screen.dart';
import 'package:i_bazaar/screens/main/create_listing/create_listing_screen.dart';
import 'package:i_bazaar/screens/main/edit_listing/edit_listing_screen.dart';
import 'package:i_bazaar/screens/main/home_screen.dart';
import 'package:i_bazaar/screens/auth/login_screen.dart';
import 'package:i_bazaar/screens/main/item/item_screen.dart';
import 'package:i_bazaar/screens/main/listings/listings_screen.dart';
import 'package:i_bazaar/screens/main/main_screen.dart';
import 'package:i_bazaar/screens/main/profile_screen.dart';
import 'package:i_bazaar/screens/main/search/search_screen.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
    GoRoute(path: "/adspace", builder: (context, state) => const AdspaceScreen()),
    GoRoute(path: "/create-listing", builder: (context, state) => const CreateListingScreen()),
    GoRoute(path: "/cart", builder: (context, state) => const CartScreen()),


    GoRoute(path: "/edit-listing", builder: (context, state) {
      final item = state.extra as Item;
      return EditListingScreen(item);
    }),

    GoRoute(
      path: "/item",
      builder: (context, state) {
        final id = state.uri.queryParameters["id"]!;
        return ItemScreen(itemID: id);
      }
    ),

    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(path: "/", builder:  (context, state) => HomeScreen()),
        GoRoute(path: "/search", builder:  (context, state) => SearchScreen()),
        GoRoute(path: "/chat", builder: (context, state) => ChatScreen()),
        GoRoute(path: "/listings", builder: (context, state) => ListingsScreen()),
        GoRoute(path: "/profile", builder: (context, state) => ProfileScreen()),
    ])
  ]
);
