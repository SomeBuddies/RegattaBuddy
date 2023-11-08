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
        color: Colors.green,
        constraints: const BoxConstraints.expand(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("Profile", style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              Text("user: ${userData.asData?.value.email ?? "Loading..."}",
                  style: const TextStyle(fontSize: 20)),
              Text("name: ${userData.asData?.value.firstName ?? "Loading..."} ",
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Card(
                shape: const StadiumBorder(),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.antiAlias,
                elevation: 1,
                child: ListTile(
                  onTap: () {
                    showLoadingSpinner();
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(HomePage.route));
                    ref.read(authStateNotiferProvider.notifier).signout();
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
}
