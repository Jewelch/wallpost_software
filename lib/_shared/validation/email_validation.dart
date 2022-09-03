import 'package:email_validator/email_validator.dart' as emailValidatorLibrary;

class EmailValidator {
  static bool isEmailValid(String email) {
    return emailValidatorLibrary.EmailValidator.validate(email);
  }
}
