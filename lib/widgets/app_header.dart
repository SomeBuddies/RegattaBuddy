import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/pages/profile_page.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  const AppHeader({
    this.automaticallyImplyLeading = true,
    this.showAuthButton = true,
    super.key,
  });

  const AppHeader.hideAllButtons({
    this.automaticallyImplyLeading = false,
    this.showAuthButton = false,
    super.key,
  });

  const AppHeader.hideAuthButton({
    this.automaticallyImplyLeading = true,
    this.showAuthButton = false,
    super.key,
  });

  final bool automaticallyImplyLeading;
  final bool showAuthButton;

  @override
  State<AppHeader> createState() => _AppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppHeaderState extends State<AppHeader> {
  final Logger logger = getLogger('AppHeader');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: getAuthButton(widget.showAuthButton),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.sailing),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium,
              children: const <TextSpan>[
                TextSpan(text: "R", style: TextStyle(color: Colors.red)),
                TextSpan(text: "egatta"),
                TextSpan(text: "B", style: TextStyle(color: Colors.red)),
                TextSpan(text: "uddy")
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getAuthButton(bool showAuthButton) {
    if (!showAuthButton) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, ProfilePage.route),
            child: const Icon(
              Icons.account_circle,
              size: 26.0,
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, LoginPage.route),
            child: const Icon(
              Icons.login,
              size: 26.0,
            ),
          );
        }
      },
    );
  }
}
