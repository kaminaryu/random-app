# i_bazaar

A Flutter marketplace app — browse items, chat, manage listings (UI-only, mock data).

## Project

- **Stack:** Flutter (Material 3), Dart SDK ^3.11.1
- **Entry point:** `lib/main.dart` → `MyApp` → `MaterialApp.router`
- **Routing:** `go_router` — shell route for main tabs, standalone routes for auth/adspace/chat-detail
- **State:** `SharedPreferences` + `ValueNotifier` for login; no state management library

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
    item.dart                — Item model (name, price, desc, seller, stock, status, imgSrc)
    conversation.dart        — Conversation model (id, otherUser, messages)
    message.dart             — Message model (senderId, receiverId, text, timestamp, isSentByMe)
  screens/
    auth/                    — LoginScreen, RegisterScreen, AuthPlaceholderScreen
    main/                    — HomeScreen, SearchScreen, ChatScreen, ChatDetailScreen,
                               ListingsScreen, ProfileScreen, AdspaceScreen, MainScreen
  widgets/
    auth/                    — AuthTextField, AuthPasswordField
    chat/                    — ConversationTile, MessageBubble
    homepage/                — HomeHero, ItemCard, SectionTitle
    listings/                — ListingCard
    main/                    — MainAppBar, MainNavBar
  services/
    prefs_service.dart       — SharedPreferences wrapper (login status)
  data/
    mock_lists.dart          — Static mock Item list
```

### Key flows

- **Auth:** Login/Register → sets SharedPreferences bool → `ValueNotifier` rebuilds ProfileScreen
- **Navigation:** `MainNavBar` (BottomNavigationBar) + `MainAppBar` → `MainScreen` (Scaffold) → child screen via `ShellRoute`
- **Home:** `CustomScrollView` with slivers → 2-column grid of `ItemCard` from `MockingList`
- **Profile:** Shows signed-in state (avatar, theme picker, adspace link, info cards, logout) or signed-out prompt

## Conventions

- **Naming:** Files/folders snake_case; classes PascalCase; constructors use `const` where possible
- **State:** `StatefulWidget` + `setState`; no BLoC/Provider/Riverpod yet
- **Imports:** Package imports before relative; no barrel files
- **Models:** Immutable `const` constructors with named params + `required`
- **Widgets:** Composable small widgets, each in its own file under `widgets/<domain>/`
- **Testing:** `flutter_test`; tests use `pumpWidget`, `find`, `expect`
- **Linting:** `flutter_lints` (recommended set)
- **No backend:** All data is static mocks; services marked as "temporary only"
- **Memory file:** This file (`AGENTS.md`) is the single source of project context — always read it first and update it when project knowledge changes. Do not create additional memory files.
- **Code exploration:** Always use the Codegraph tools (`codegraph_context`, `codegraph_explore`, `codegraph_search`, `codegraph_trace`) for understanding code structure, finding symbols, and tracing call paths — they are faster and more accurate than chaining `grep`/`read_file` calls.

## Notes

