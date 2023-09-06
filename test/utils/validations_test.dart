import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/utils/validations.dart';

void main() {
  String generateRandomString(int length) =>
      List.generate(length, (_) => 'x').join('');

  group('Should validate email', () {
    var emailAndValidationResult = {
      "test@gmail.com": null,
      "john": 'Please enter a valid email address',
      "regatta.com": 'Please enter a valid email address',
      "@regatta.com": 'Please enter a valid email address',
      generateRandomString(256): 'Please enter a valid email address',
      "🤡": 'Please enter a valid email address'
    };
    emailAndValidationResult.forEach((email, validationResult) {
      test("$email -> $validationResult", () {
        expect(validateEmail(email), validationResult);
      });
    });
  });

  group('Should validate password', () {
    var passwordAndValidationResult = {
      null: 'Please enter a password',
      "": 'Please enter a password',
      "john": 'Password must be at least 6 characters',
      generateRandomString(256): 'Password must be less than 255 characters',
      "3up3rP@ssw0rd": null,
      "password": null
    };
    passwordAndValidationResult.forEach((password, validationResult) {
      test("$password -> $validationResult", () {
        expect(validatePassword(password), validationResult);
      });
    });
  });

  group('Should validate confirm password', () {
    var confirmPassword = 'p@ssword';

    var passwordAndValidationResult = {
      null: 'Please enter a password',
      "": 'Please enter a password',
      "notmatching": 'Passwords do not match',
      "p@ssword": null
    };
    passwordAndValidationResult.forEach((password, validationResult) {
      test("$password -> $validationResult", () {
        expect(validateConfirmPassword(password, confirmPassword),
            validationResult);
      });
    });
  });

  group('Should validate short text input', () {
    var textLabel = 'testInput';

    var textAndValidationResult = {
      null: 'Please enter a $textLabel',
      "": 'Please enter a $textLabel',
      generateRandomString(256): '$textLabel must be less than 255 characters',
      "3up3rP@ssw0rd": null,
      "password": null
    };
    textAndValidationResult.forEach((text, validationResult) {
      test("$text -> $validationResult", () {
        expect(validateShortTextInput(text, textLabel), validationResult);
      });
    });
  });
}
