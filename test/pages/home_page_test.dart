// ignore_for_file: scoped_providers_should_specify_dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/search_page.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';

import '../firebase_mock.dart';
import '../mock_auth_state_notifier.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

const validRegattaCode = '12345';
const invalidRegattaCode = '0';

void main() {
  setupFirebaseMocks();

  setUpAll(() async {
    registerFallbackValue(FakeRoute());
    await Firebase.initializeApp();
  });
  TestWidgetsFlutterBinding.ensureInitialized();

  var mockedRoutes = {
    SearchPage.route: (_) => const Scaffold(
          body: Text("mockedSearchPage"),
        ),
    EventCreationPage.route: (_) => const Scaffold(
          body: Text("mockedCreatePage"),
        ),
    RegattaDetailsPage.route: (_) => const Scaffold(
          body: Text("mockedRegattaDetailsPage"),
        ),
  };

  testWidgets('finds all available buttons', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateNotiferProvider.overrideWith(
            () => MockAuthStateNotifier(),
          ),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    expect(find.text('Twoje wydarzenia'), findsOneWidget);
    expect(find.text('Zorganizuj wydarzenie'), findsOneWidget);
    expect(find.text('Przeglądaj wydarzenia'), findsOneWidget);
  });

  testWidgets("Navigates to SearchPage on search button click", (tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateNotiferProvider.overrideWith(
            () => MockAuthStateNotifier(),
          ),
        ],
        child: MaterialApp(
          home: const HomePage(),
          routes: mockedRoutes,
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    expect(find.text('mockedSearchPage'), findsNothing);

    await tester.tap(find.text('Przeglądaj wydarzenia'));
    await tester.pumpAndSettle();

    verify(() => mockObserver.didPush(any(), any()));
    expect(find.text('mockedSearchPage'), findsOneWidget);
  });

  testWidgets("Navigates to UserRegattasPage on your regattas button click", (tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateNotiferProvider.overrideWith(
            () => MockAuthStateNotifier(),
          ),
        ],
        child: MaterialApp(
          home: const HomePage(),
          routes: mockedRoutes,
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    expect(find.text('mockedSearchPage'), findsNothing);

    await tester.tap(find.text('Twoje wydarzenia'));
    await tester.pumpAndSettle();

    verify(() => mockObserver.didPush(any(), any()));
    expect(find.text('mockedSearchPage'), findsOneWidget);
  });

  testWidgets("Navigates to CreatePage on create button click and confirmation", (tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateNotiferProvider.overrideWith(
            () => MockAuthStateNotifier(),
          ),
        ],
        child: MaterialApp(
          home: const HomePage(),
          routes: mockedRoutes,
          navigatorObservers: [mockObserver],
        ),
      ),
    );

    expect(find.text('mockedCreatePage'), findsNothing);

    await tester.tap(find.text('Zorganizuj wydarzenie'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tak'));
    await tester.pumpAndSettle();

    verify(() => mockObserver.didPush(any(), any()));
    expect(find.text('mockedCreatePage'), findsOneWidget);
  });
}
