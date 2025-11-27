class ValidateCheck {
  static String? validateEmail(String? value) {
    const pattern =
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final kEmailValid = RegExp(pattern);
    bool isValid = kEmailValid.hasMatch(value.toString());
    if (value!.isEmpty) {
      return null;
    } else if (isValid == false) {
      return 'Enter valid email address';
    }
    return null;
  }

  static String? validateEmptyText(String? value, String? message) {
    if (value == null || value.isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    value = value.trim();

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must contain only digits';
    }

    if (value.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }

    // if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
    //   return 'Enter a valid Indian mobile number';
    // }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // else if (value.length < 8) {
    //   return 'Minimum password should ';
    // }
    return null;
  }

  static String? validateDuration(String? value) {
    final duration = int.tryParse(value?.trim() ?? '') ?? 0;

    if (duration == 0) {
      return 'Duration is required';
    } else if (duration > 30) {
      return 'Duration cannot be more than 30 days';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    final confirm = value?.trim() ?? '';
    final pass = password?.trim() ?? '';

    if (confirm.isEmpty) {
      return 'Confirm Password is required';
    } else if (confirm != pass) {
      return 'Confirm Password must be same as password';
    }
    return null;
  }

  static String? validatePostalCode(String? postalCode) {
    if (postalCode == null || postalCode.trim().isEmpty) {
      return null;
    }

    postalCode = postalCode.trim();

    if (postalCode.length > 6) {
      return 'Postal code must be exactly 6 digits';
    }

    final regex = RegExp(r'^[1-9][0-9]{5}$');

    if (!regex.hasMatch(postalCode)) {
      return 'Enter a valid 6-digit Indian postal code';
    }

    return null;
  }
}
