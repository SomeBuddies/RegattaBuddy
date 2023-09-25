import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/search_page.dart';
import 'package:regatta_buddy/pages/user_regattas.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String route = '/';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        ref.read(authStateNotiferProvider.notifier).checkIfLoggedIn();
        ref.watch(authStateNotiferProvider).whenOrNull(
              unauthenticated: (message) =>
                  Navigator.of(context).pushReplacementNamed(LoginPage.route),
            );
      },
    );

    return Scaffold(
      appBar: const AppHeader(),
      body: Container(
        color: Colors.green,
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildButton(
              onTap: () => handleJoinRegatta(context),
              title: 'Join',
              text: 'Use code to join an existing regatta',
            ),
            const SizedBox(height: 20.0),
            buildButton(
              onTap: () => Navigator.pushNamed(context, UserRegattasPage.route),
              title: 'Your regattas',
              text: 'View your upcoming regattas',
            ),
            const SizedBox(height: 20.0),
            buildButton(
              onTap: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'New regatta',
                  text: 'Are you sure you want to start creating a new regatta?',
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, EventCreationPage.route);
                  },
                  confirmBtnText: 'Yes',
                );
              },
              title: 'Create',
              text: 'Create a new regatta',
            ),
            const SizedBox(height: 20.0),
            buildButton(
              onTap: () => Navigator.pushNamed(context, SearchPage.route),
              title: 'Search',
              text: 'Search for upcoming regattas in your area',
            )
          ],
        ),
      ),
    );
  }

  void handleJoinRegatta(
    BuildContext context,
  ) {
    var regattaCode = '';

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      confirmBtnText: 'Sign up',
      customAsset: 'assets/images/search.png',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Enter regatta code',
          prefixIcon: Icon(
            Icons.lock_open,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        onChanged: (value) => regattaCode = value,
      ),
      onConfirmBtnTap: () async {
        if (!isCodeValid(regattaCode)) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input valid regatta code.',
          );
          return;
        }
        Navigator.pop(context);
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: '{Regatta Name}',
          text: "You successfully joined the regatta!",
        );
        if (context.mounted) Navigator.pushNamed(context, RegattaDetailsPage.route);
      },
    );
  }

  bool isCodeValid(String regattaCode) {
    var tempAllowedCode = '12345';
    if (regattaCode.length >= 3 && regattaCode == tempAllowedCode) {
      return true;
    }
    return false;
  }

  Card buildButton({
    required VoidCallback onTap,
    required String title,
    required String text,
  }) {
    return Card(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.only(
          left: 30,
        ),
        title: Text(title),
        subtitle: Text(text),
      ),
    );
  }
}
