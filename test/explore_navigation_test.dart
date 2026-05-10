import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mapme/screens/detail_screen.dart';
import 'package:mapme/screens/list_screen.dart';
import 'package:mapme/theme/app_theme.dart';

void main() {
  testWidgets(
    'tapping an Explore item opens Detail without layout assertion errors',
    (WidgetTester tester) async {
      final List<FlutterErrorDetails> frameworkErrors = <FlutterErrorDetails>[];
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        frameworkErrors.add(details);
      };
      addTearDown(() => FlutterError.onError = oldOnError);

      final GoRouter router = GoRouter(
        initialLocation: '/list',
        routes: <RouteBase>[
          GoRoute(
            path: '/list',
            builder: (BuildContext context, GoRouterState state) =>
                const ListScreen(),
          ),
          GoRoute(
            path: '/business/:id',
            builder: (BuildContext context, GoRouterState state) {
              final int id =
                  int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
              return DetailScreen(businessId: id);
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: appTheme,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Driftwood Coffee').first);
      await tester.pumpAndSettle();

      expect(find.text('Book a table'), findsOneWidget);
      expect(frameworkErrors, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}
