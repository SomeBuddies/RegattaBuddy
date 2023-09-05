import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/utils/notification_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  static const String route = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    verifyUserIsAuthenticated();
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.user;

    if (userData == null) {
      showNotificationToast(context, "User not found");
    }

    return Scaffold(
      appBar: const AppHeader.hideAuthButton(),
      body: Container(
        color: Colors.green,
        constraints: const BoxConstraints.expand(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("Profile", style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              Text("user: ${userData?.email}",
                  style: const TextStyle(fontSize: 20)),
              Text("name: ${userData?.firstName}",
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Card(
                shape: const StadiumBorder(),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.antiAlias,
                elevation: 1,
                child: ListTile(
                  onTap: () async => {
                    showLoadingSpinner(),
                    await FirebaseAuth.instance.signOut(),
                    Navigator.of(context).popUntil(ModalRoute.withName(HomePage.route)),
                  },
                  contentPadding: const EdgeInsets.only(
                    left: 30,
                  ),
                  title: const Text("Logout"),
                  subtitle: const Text(""),
                ),
              )
            ]),
      ),
    );
  }
  void showLoadingSpinner() {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void verifyUserIsAuthenticated() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, LoginPage.route);
    }
  }
}
