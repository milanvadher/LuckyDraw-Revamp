import 'package:flutter/foundation.dart';

import 'auth_api_provider.dart';

class Repository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  // Login User
  Future login({
    @required String mobileNo,
    @required String password,
  }) {
    return _authApiProvider.login(
      mobileNo: mobileNo,
      password: password,
    );
  }
  
  // Send OTP
  Future sendOtp({
    @required String mobileNo,
    @required int otp,
  }) {
    return _authApiProvider.sendOtp(
      mobileNo: mobileNo,
      otp: otp,
    );
  }
}
