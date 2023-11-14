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
import 'package:regatta_buddy/pages/user_regattas.dart';
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
    UserRegattasPage.route: (_) => const Scaffold(
          body: Text("mockedUserRegattasPage"),
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

    expect(find.text('Your events'), findsOneWidget);
    expect(find.text('Organize event'), findsOneWidget);
    expect(find.text('Browse events'), findsOneWidget);
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

    await tester.tap(find.text('Browse events'));
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

    await tester.tap(find.text('Your events'));
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

    await tester.tap(find.text('Organize event'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    verify(() => mockObserver.didPush(any(), any()));
    expect(find.text('mockedCreatePage'), findsOneWidget);
  });
}
