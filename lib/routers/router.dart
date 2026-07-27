import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/auth/register_screen.dart';
import 'package:i_bazaar/screens/profile/adspace_screen.dart';
import 'package:i_bazaar/screens/main/cart/cart_screen.dart';
import 'package:i_bazaar/screens/main/create_listing/create_listing_screen.dart';
import 'package:i_bazaar/screens/main/edit_listing/edit_listing_screen.dart';
import 'package:i_bazaar/screens/main/home_screen.dart';
import 'package:i_bazaar/screens/auth/login_screen.dart';
import 'package:i_bazaar/screens/main/item/item_screen.dart';
import 'package:i_bazaar/screens/main/listings/listings_screen.dart';
import 'package:i_bazaar/screens/main/main_screen.dart';
import 'package:i_bazaar/screens/profile/profile_screen.dart';
import 'package:i_bazaar/screens/main/search/search_screen.dart';
import 'package:i_bazaar/screens/profile/rate_products_screen.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
    GoRoute(path: "/create-listing", builder: (context, state) => const CreateListingScreen()),
    GoRoute(path: "/cart", builder: (context, state) => const CartScreen()),

    // ProfileScreen
    GoRoute(path: "/adspace", builder: (context, state) => const AdspaceScreen()),
    GoRoute(path: "/rate-products", builder: (context, state) => const RateProductsScreen()),


    GoRoute(path: "/edit-listing", builder: (context, state) {
      final item = state.extra as Item;
      return EditListingScreen(item);
    }),

    GoRoute(
      path: "/item",
      builder: (context, state) {
        final id = state.uri.queryParameters["id"]!;
        return ItemScreen(itemId: id);
      }
    ),

    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(path: "/",         pageBuilder: (context, state)  => NoTransitionPage(child: HomeScreen())),
        GoRoute(path: "/search",   pageBuilder: (context, state)  => NoTransitionPage(child: SearchScreen())),
        GoRoute(path: "/listings", pageBuilder: (context, state)  => NoTransitionPage(child: ListingsScreen())),
        GoRoute(path: "/profile",  pageBuilder: (context, state)  => NoTransitionPage(child: ProfileScreen())),
    ])
  ]
);
