class Validation {
  static String mobileNo(String value) {
    if (value.isEmpty) {
      return 'Mobile No. is required';
    } else if (value.length != 10) {
      return 'Enter valid Mobile No.';
    }
    return null;
  }

  static String password(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String verifyPassword(String matchValue, String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (matchValue != value) {
      return 'Password and Verify Password does not match';
    }
    return null;
  }

  static String otp(String value) {
    if (value.isEmpty) {
      return 'OTP is required';
    } else if (value.length != 6) {
      return 'Enter Valid OTP';
    }
    return null;
  }

  static String username(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  static String email(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Please Enter a Proper Email address';
    }
    return null;
  }

  static String notificationtext(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }
}
