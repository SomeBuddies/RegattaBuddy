String? validateEmail(String? email) {
  // RFC 5322 compliant regex | https://html.spec.whatwg.org/multipage/input.html#e-mail-state-%28type=email%29
  if (!RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(email ?? '')) {
    return 'Proszę, wprowadź poprawny adres email';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Proszę, wprowadź hasło';
  }
  if (password.length < 6) {
    return 'Hasło musi mieć przynajmniej 6 znaków';
  }
  if (password.length > 255) {
    return 'Hasło musi mieć mniej niż 256 znaków';
  }
  return null;
}

String? validateConfirmPassword(String? password, String correctPassword) {
  if (password == null || password.isEmpty) {
    return 'Proszę, wprowadź hasło';
  }
  if (password != correctPassword) {
    return 'Hasła się różnią';
  }
  return null;
}

String? validateShortTextInput(String? text, String textLabel) {
  if (text == null || text.isEmpty) {
    return 'Proszę, wprowadź $textLabel';
  }
  if (text.length > 255) {
    return '$textLabel musi mieć mniej niż 256 znaków';
  }
  return null;
}
