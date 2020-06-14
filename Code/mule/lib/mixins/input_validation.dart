import 'package:email_validator/email_validator.dart';

class InputValidation {
  String validateEmail(String email) {
    if (!EmailValidator.validate(email.trim(), true)) {
      return 'Not a valid email';
    }

    return null;
  }

  String validateNewPassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password cannot be empty!';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String validateNotEmptyInput(String value) {
    if (value.trim().isEmpty) {
      return 'Cannot be empty!';
    }
    return null;
  }
}
