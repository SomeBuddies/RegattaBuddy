import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/services/authentication_service.dart';
import 'package:regatta_buddy/utils/validations.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String route = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          validateShortTextInput(firstName, 'first name'),
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    TextFormField(
                      controller: lastNameController,
                      validator: (firstName) =>
                          validateShortTextInput(firstName, 'last name'),
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
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
                        labelText: 'Password',
                      ),
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (confirmPassword) => validateConfirmPassword(
                          confirmPassword, passwordController.text),
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUp(context);
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ),
                    StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return const Text('Logged in');
                          } else {
                            return const Text('Not logged in');
                          }
                        }),
                  ]),
            )));
  }

  Future signUp(BuildContext context) async {
    showLoadingSpinner();
    final authenticationService = Provider.of<AuthenticationService>(context, listen: false);
    var registrationData = RegistrationData(
      email: emailController.text,
      password: passwordController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
    );

    var newUserUid = await authenticationService.signUp(registrationData);

    if (newUserUid == null) {
      showToast('Error when creating user');
      Navigator.pop(context);
      return;
    }

    await Provider.of<UserProvider>(context, listen: false).loadUserData();
    Navigator.of(context).popUntil(ModalRoute.withName(HomePage.route));
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
