import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/utils/validations.dart';

void main() {
  String generateRandomString(int length) =>
      List.generate(length, (_) => 'x').join('');

  group('Should validate email', () {
    var emailAndValidationResult = {
      "test@gmail.com": null,
      "john": 'Proszę, wprowadź poprawny adres email',
      "regatta.com": 'Proszę, wprowadź poprawny adres email',
      "@regatta.com": 'Proszę, wprowadź poprawny adres email',
      generateRandomString(256): 'Proszę, wprowadź poprawny adres email',
      "🤡": 'Proszę, wprowadź poprawny adres email'
    };
    emailAndValidationResult.forEach((email, validationResult) {
      test("$email -> $validationResult", () {
        expect(validateEmail(email), validationResult);
      });
    });
  });

  group('Should validate password', () {
    var passwordAndValidationResult = {
      null: 'Proszę, wprowadź hasło',
      "": 'Proszę, wprowadź hasło',
      "john": 'Hasło musi mieć przynajmniej 6 znaków',
      generateRandomString(256): 'Hasło musi mieć mniej niż 256 znaków',
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
      null: 'Proszę, wprowadź hasło',
      "": 'Proszę, wprowadź hasło',
      "notmatching": 'Hasła się różnią',
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
      null: 'Proszę, wprowadź $textLabel',
      "": 'Proszę, wprowadź $textLabel',
      generateRandomString(256): '$textLabel musi mieć mniej niż 256 znaków',
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
