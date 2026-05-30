import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:htmarevived/screens/map_screen.dart';
import 'package:htmarevived/models/business.dart';

void main() {
  testWidgets('map screen', (WidgetTester tester) async {
    final List<Business> businesses = <Business>[
      Business(
        id: 2,
        name: 'Tasty Cafe',
        category: 'cafe',
        addressLine1: '123 Main',
        city: 'Buffalo',
        state: 'MN',
        postalCode: '',
        owner: null,
        phone: null,
        website: null,
        hours: null,
        latitude: 45.0,
        longitude: -93.0,
        storefrontImage: '',
      ),
    ];

    // Initially do not show a selected business summary
    await tester.pumpWidget(
      MaterialApp(
        home: MapScreen(
          businessesFuture: Future.value(businesses),
          initialSelected: false,
          mapSupportedOverride: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tasty Cafe'), findsNothing);
    expect(find.text('No places match this category.'), findsOneWidget);

    // Rebuild with selection enabled - should show the summary
    await tester.pumpWidget(
      MaterialApp(
        home: MapScreen(
          key: UniqueKey(),
          businessesFuture: Future.value(businesses),
          initialSelected: true,
          mapSupportedOverride: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tasty Cafe'), findsOneWidget);
    expect(find.textContaining('123 Main'), findsOneWidget);
  });

  testWidgets('tapping map background dismisses the panel', (WidgetTester tester) async {
    final List<Business> businesses = <Business>[
      Business(
        id: 3,
        name: 'River Roasters',
        category: 'cafe',
        addressLine1: '456 Elm St',
        city: 'Buffalo',
        state: 'MN',
        postalCode: '',
        owner: null,
        phone: null,
        website: null,
        hours: null,
        latitude: 45.1,
        longitude: -93.1,
        storefrontImage: '',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MapScreen(
          businessesFuture: Future.value(businesses),
          initialSelected: true,
          mapSupportedOverride: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Panel is visible with the selected business name
    expect(find.text('River Roasters'), findsOneWidget);

    // Tap the open map area — between the top filter bar and the bottom panel.
    // The panel occupies the lower portion of the Stack; y≈180 is safely above it.
    await tester.tapAt(const Offset(400, 180));
    await tester.pumpAndSettle();

    // Panel should be dismissed — business name is no longer rendered
    expect(find.text('River Roasters'), findsNothing);
  });
}
