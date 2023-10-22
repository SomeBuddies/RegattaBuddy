import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/register_page.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/utils/validations.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class LoginPage extends ConsumerStatefulWidget {
  LoginPage({super.key});
  static const String route = '/login';

  final logger = getLogger('LoginPage');

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool hasNavigated = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      authStateNotiferProvider,
      (previous, next) {
        next.maybeWhen(
          orElse: () => null,
          authenticated: (user) {
            if (!hasNavigated) {
              Navigator.of(context).pushNamedAndRemoveUntil(HomePage.route, (Route route) => false);

              hasNavigated = true;
            }
          },
          unauthenticated: (message) {
            if (!hasNavigated) {
              showToast(message);
              //Removes loading spinner
              showOnlyLoginScreen(context);
            }
          },
        );
      },
    );

    return Scaffold(
      appBar: const AppHeader.hideAuthButton(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                validator: (email) => validateEmail(email),
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(context, RegisterPage.route))
                  ],
                ),
              ),
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const Text('Logged in');
                  }
                  return const Text('Not logged in');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showOnlyLoginScreen(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.settings.name == LoginPage.route);
  }

  Future signIn() async {
    showLoadingSpinner();
    ref.read(authStateNotiferProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
        );
  }

  void showLoadingSpinner() {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
