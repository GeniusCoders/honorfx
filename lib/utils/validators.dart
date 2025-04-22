class Validators {
  // Email validation
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  // Phone number validation based on country code
  static bool isValidPhoneNumber(String phoneNumber, String countryCode) {
    // Remove any non-digit characters
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Different validation patterns based on country code
    switch (countryCode) {
      case 'US': // United States
        return phoneNumber.length == 10;
      case 'GB': // United Kingdom
        return phoneNumber.length >= 10 && phoneNumber.length <= 11;
      case 'IN': // India
        return phoneNumber.length == 10;
      case 'UAE': // UAE
        return phoneNumber.length == 9;
      case 'AU': // Australia
        return phoneNumber.length >= 9 && phoneNumber.length <= 10;
      case 'CA': // Canada
        return phoneNumber.length == 10;
      case 'SG': // Singapore
        return phoneNumber.length == 8;
      default:
        // For most countries, a reasonable length is between 8 and 12 digits
        return phoneNumber.length >= 8 && phoneNumber.length <= 12;
    }
  }

  // Password validation
  static bool isValidPassword(String password) {
    // At least 8 characters, with at least one uppercase, one lowercase, and one number
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Name validation
  static bool isValidName(String name) {
    // At least 2 characters, only letters and spaces
    final nameRegExp = RegExp(r'^[a-zA-Z ]{2,}$');
    return nameRegExp.hasMatch(name);
  }
}
