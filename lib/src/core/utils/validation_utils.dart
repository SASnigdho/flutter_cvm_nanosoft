class ValidationUtils {
  static bool isNameLengthValid(String name) {
    return name.isNotEmpty && name.length >= 3;
  }

  static bool isEmailPatternValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
