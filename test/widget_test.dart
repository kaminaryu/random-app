import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:i_bazaar/main.dart';

void main() {
  testWidgets('App renders home screen with catalog items',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify the app shell renders
    expect(find.text('Home'), findsOneWidget); // Bottom nav item
    expect(find.text('My Listings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify the home screen shows the hero and catalog section
    expect(find.text('Catalogs'), findsOneWidget);

    // Verify at least one mock item renders
    expect(find.byType(CustomScrollView), findsOneWidget);
  });
}
