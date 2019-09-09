import 'package:flutter/foundation.dart';
import 'package:youth_app/src/model/app_setting.dart';
import 'package:youth_app/src/model/question.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/repository/app_settings_api_provider.dart';
import 'package:youth_app/src/repository/coupons_api_provider.dart';
import 'package:youth_app/src/repository/question_api_provider.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'auth_api_provider.dart';

class Repository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();
  final CouponsApiProvider _couponApiProvider = CouponsApiProvider();
  final QuestionApiProvider _questionApiProvider = QuestionApiProvider();
  final AppSettingApiProvider _appSettingApiProvider = AppSettingApiProvider();

  // Login User
  Future<User> login({
    @required String mobileNo,
    @required String password,
  }) async {
    User user = await _authApiProvider.login(
      mobileNo: mobileNo,
      password: password,
    );
    await Config.saveObjectJson('$userDataKey', user);
    return user;
  }

  // Edit User
  Future<User> editUser({
    @required String mobileNo,
    @required String username,
  }) async {
    User user = await _authApiProvider.editUser(
      mobileNo: mobileNo,
      username: username,
    );
    await Config.saveObjectJson('$userDataKey', user);
    return user;
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

  // Reset Password
  Future<User> resetPassword({
    @required String mobileNo,
    @required String password,
  }) async {
    User user = await _authApiProvider.resetPassword(
      mobileNo: mobileNo,
      password: password,
    );
    await Config.saveObjectJson('$userDataKey', user);
    return user;
  }

  // Get user Coupons
  Future getUserCoupons() {
    return _couponApiProvider.getUserCoupons();
  }

  // Get Question
  Future<String> generateCoupon({
    @required int questionState,
  }) {
    return _couponApiProvider.generateCoupon(
      questionState: questionState,
    );
  }

  // Assign user Coupons to Slot
  Future assignCoupon({
    @required int coupon,
    @required List<int> date,
  }) {
    return _couponApiProvider.assignCoupon(
      coupon: coupon,
      date: date,
    );
  }

  // Get Question
  Future<Question> getQuestion({
    @required int questionState,
  }) {
    return _questionApiProvider.getQuestion(
      questionState: questionState,
    );
  }

  // Save Userdata
  Future<User> saveUserData({
    @required int points,
    @required int questionState,
    String firebaseToken
  }) async {
    User user = await _authApiProvider.saveUserData(
      points: points,
      questionState: questionState,
      firebaseToken: firebaseToken,
    );
    await Config.saveObjectJson('$userDataKey', user);
    return user;
  }

  Future<AppSetting> getAppSettings() {
    return _appSettingApiProvider.getAppSettings();
  }
}
