# i_bazaar

A Flutter marketplace app — browse items, chat, manage listings (Supabase backend).

## Project

- **Stack:** Flutter (Material 3), Dart SDK ^3.11.1
- **Entry point:** `lib/main.dart` → `MyApp` → `MaterialApp.router`
- **Routing:** `go_router` — shell route for main tabs, standalone routes for auth/adspace/chat-detail/create-listing
- **Auth:** Supabase (`supabase_flutter`) — email/password auth with `user_metadata["username"]`
- **Database:** Supabase `catalog` table with `user_profiles` join; storage bucket `catalog-images`

## Commands

| Action | Command |
|--------|---------|
| Run (dev) | `flutter run` |
| Build APK | `flutter build apk` |
| Test | `flutter test` |
| Analyze | `flutter analyze` |
| Format | `dart format .` |
| Get deps | `flutter pub get` |
| Upgrade | `flutter pub upgrade --major-versions` |

## Architecture

```
lib/
  main.dart                  — App entry point, MaterialApp.router, theme
  routers/router.dart        — GoRouter config (shell + standalone routes)
  models/
    item.dart                — Item model (id, name, price, desc, sellerID, sellerName, ...)
    conversation.dart        — Conversation model (id, otherUser, messages)
    message.dart             — Message model (senderId, receiverId, text, timestamp, isSentByMe)
  screens/
    auth/                    — LoginScreen, RegisterScreen, AuthPlaceholderScreen
    main/                    — HomeScreen, SearchScreen, ChatScreen, ChatDetailScreen,
                               ListingsScreen, ProfileScreen, AdspaceScreen, MainScreen,
                               CreateListingScreen
  widgets/
    auth/                    — AuthTextField, AuthPasswordField, AuthErrorSnackBar
    chat/                    — ConversationTile, MessageBubble
    homepage/                — HomeHero, ItemCard, SectionTitle
    listings/                — ListingCard
    main/                    — MainAppBar, MainNavBar
  services/
    catalog_handler.dart     — Supabase queries for catalog items (fetch, search, price range)
    listing_handler.dart     — Supabase mutations for listings (create with image upload)
```

### Key flows

- **Auth:** Login/Register via Supabase auth → `onAuthStateChange` stream rebuilds ProfileScreen
- **Navigation:** `MainNavBar` (BottomNavigationBar) + `MainAppBar` → `MainScreen` (Scaffold) → child screen via `ShellRoute`
- **Home:** `CustomScrollView` with slivers → 2-column grid of `ItemCard` fetched from Supabase `catalog` table
- **Profile:** Shows signed-in state (avatar, username, email, theme picker, adspace link, info cards, logout) or signed-out prompt
- **Listings:** Infinite-scroll list of all items from `catalog`; FAB (+) → `CreateListingScreen`
- **Create Listing:** Form with image picker + item fields → inserts into Supabase `catalog`, uploads image to `catalog-images/{sellerId}/{name}.jpg`

### Supabase schema (catalog)

| Column | Type | Source |
|--------|------|--------|
| `id` | int8 | auto |
| `item_name` | text | form input |
| `price` | float8 | form input |
| `desc` | text | form input |
| `short_desc` | text | form input |
| `stock` | int4 | form input |
| `is_public` | bool | form toggle |
| `rating` | float8 | default 0.0 |
| `amount_sold` | int4 | default 0 |
| `item_created_at` | timestamptz | auto |
| `seller_id` | uuid (FK → user_profiles) | current user ID |

Image storage: `catalog-images/{sellerId}/{itemName}.jpg`

## Conventions

- **Naming:** Files/folders snake_case; classes PascalCase; constructors use `const` where possible
- **State:** `StatefulWidget` + `setState`; no BLoC/Provider/Riverpod yet
- **Imports:** Package imports before relative; no barrel files
- **Models:** Immutable `const` constructors with named params + `required`
- **Widgets:** Composable small widgets, each in its own file under `widgets/<domain>/`
- **Testing:** `flutter_test`; tests use `pumpWidget`, `find`, `expect`
- **Linting:** `flutter_lints` (recommended set)
- **Backend:** Supabase for auth, database (`catalog` table), and storage (`catalog-images` bucket)
- **Memory file:** This file (`AGENTS.md`) is the single source of project context — always read it first and update it when project knowledge changes. Do not create additional memory files.
- **Code exploration:** Always use the Codegraph tools (`codegraph_context`, `codegraph_explore`, `codegraph_search`, `codegraph_trace`) for understanding code structure, finding symbols, and tracing call paths — they are faster and more accurate than chaining `grep`/`read_file` calls.

## Notes

