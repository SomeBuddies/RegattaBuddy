import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/pages/search_page.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/widgets/core/app_header.dart';

class HomePage extends ConsumerWidget {
  static const String route = '/';

  const HomePage({super.key});

  Card buildButton({
    required VoidCallback onTap,
    required String title,
    required String text,
  }) {
    return Card(
      shape: const StadiumBorder(),
      color: const Color(0xFF2194F0),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.only(
          left: 30,
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        subtitle: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateNotiferProvider).maybeWhen(
          initial: () => WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              ref.read(authStateNotiferProvider.notifier).checkIfLoggedIn();
            },
          ),
          unauthenticated: (message) =>
              WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              Navigator.of(context).pushReplacementNamed(LoginPage.route);
            },
          ),
          orElse: () {},
        );

    return Scaffold(
      appBar: const AppHeader(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildButton(
              onTap: () => Navigator.pushNamed(context, SearchPage.route,
                  arguments: {'isUserView': true}),
              title: 'Twoje wydarzenia',
              text: 'Zobacz swoje nadchodzące wydarzenia',
            ),
            const SizedBox(height: 30.0),
            buildButton(
              onTap: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'Zorganizuj wydarzenie',
                  text:
                      'Jesteś pewny, że chcesz zacząć tworzyć swoje wydarzenie?',
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, EventCreationPage.route);
                  },
                  confirmBtnText: 'Tak',
                  cancelBtnText: 'Anuluj',
                );
              },
              title: 'Zorganizuj wydarzenie',
              text: 'Stwórz wydarzenie do którego dołączą inni',
            ),
            const SizedBox(height: 30.0),
            buildButton(
              onTap: () => Navigator.pushNamed(context, SearchPage.route,
                  arguments: {'isUserView': false}),
              title: 'Przeglądaj wydarzenia',
              text: 'Zobacz wydarzenia innych użytkowników',
            )
          ],
        ),
      ),
    );
  }
}
