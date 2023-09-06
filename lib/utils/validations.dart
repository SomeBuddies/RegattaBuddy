
String? validateEmail(String? email) {
  // RFC 5322 compliant regex | https://html.spec.whatwg.org/multipage/input.html#e-mail-state-%28type=email%29
  if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email ?? '')) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  if (password.length > 255) {
    return 'Password must be less than 255 characters';
  }
  return null;
}

String? validateConfirmPassword(String? password, String correctPassword) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  }
  if (password != correctPassword) {
    return 'Passwords do not match';
  }
  return null;
}

String? validateShortTextInput(String? text, String textLabel) {
  if (text == null || text.isEmpty) {
    return 'Please enter a $textLabel';
  }
  if (text.length > 255) {
    return '$textLabel must be less than 255 characters';
  }
  return null;
}
