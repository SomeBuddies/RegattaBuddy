import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/utils/notification_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({super.key});

  static const String route = '/profile';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);

    userData.whenOrNull(error: (error, stackTrace) {
      getLogger("Profile Page").i(error);
      showNotificationToast(context, error.toString());
    });

    return Scaffold(
      appBar: const AppHeader.hideAuthButton(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Profile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              shape: const StadiumBorder(),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User: ${userData.asData?.value.email ?? "Loading..."}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Name: ${userData.asData?.value.firstName ?? "Loading..."}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showLoadingSpinner();
                Navigator.of(context).popUntil(
                  ModalRoute.withName(HomePage.route),
                );
                ref.read(authStateNotiferProvider.notifier).signout();
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
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
}
