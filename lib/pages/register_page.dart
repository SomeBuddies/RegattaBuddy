import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/utils/validations.dart';
import 'package:regatta_buddy/widgets/core/app_header.dart';

class RegisterPage extends StatefulHookConsumerWidget {
  const RegisterPage({super.key});

  static const String route = '/register';

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    ref.listen(
      authStateNotiferProvider,
      (previous, next) {
        next.whenOrNull(
          authenticated: (user) {
            Navigator.of(context).popUntil(ModalRoute.withName(HomePage.route));
          },
          unauthenticated: (message) {
            showToast(message);
            Navigator.pop(context);
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
                controller: firstNameController,
                validator: (firstName) =>
                    validateShortTextInput(firstName, 'imię'),
                decoration: const InputDecoration(
                  labelText: 'Imię',
                ),
              ),
              TextFormField(
                controller: lastNameController,
                validator: (firstName) =>
                    validateShortTextInput(firstName, 'nazwisko'),
                decoration: const InputDecoration(
                  labelText: 'Nazwisko',
                ),
              ),
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
                validator: (password) => validatePassword(password),
                decoration: const InputDecoration(
                  labelText: 'Hasło',
                ),
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                validator: (confirmPassword) => validateConfirmPassword(
                  confirmPassword,
                  passwordController.text,
                ),
                decoration: const InputDecoration(
                  labelText: 'Potwierdź hasło',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var registrationData = RegistrationData(
                        email: emailController.text,
                        password: passwordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                      );

                      signUp(context, registrationData);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Zarejestruj się'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp(BuildContext context, RegistrationData data) async {
    showLoadingSpinner();

    ref.read(authStateNotiferProvider.notifier).signup(data);
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
