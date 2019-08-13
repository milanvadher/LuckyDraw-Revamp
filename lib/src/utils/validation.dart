class Validation {
  static String mobileNo(String value) {
    if (value.isEmpty) {
      return 'Mobile No. is required';
    } else if (value.length != 10) {
      return 'Enter valid Mobile No.';
    }
    return null;
  }

  static String password(value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
