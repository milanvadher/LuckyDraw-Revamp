import 'package:flutter/foundation.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'auth_api_provider.dart';

class Repository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  // Login User
  Future<User> login({
    @required String mobileNo,
    @required String password,
  }) {
    return _authApiProvider.login(
      mobileNo: mobileNo,
      password: password,
    );
  }
  
  // Send OTP
  Future<bool> sendOtp({
    @required String mobileNo,
    @required int otp,
  }) {
    return _authApiProvider.sendOtp(
      mobileNo: mobileNo,
      otp: otp,
    );
  }
  
  // Register User
  Future<User> register({
    @required String mobileNo,
    @required String username,
    @required String password,
  }) {
    return _authApiProvider.registerUser(
      mobileNo: mobileNo,
      username: username,
      password: password,
    );
  }
}
