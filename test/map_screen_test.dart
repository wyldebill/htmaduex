import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapme/screens/map_screen.dart';
import 'package:mapme/models/business.dart';

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
}
