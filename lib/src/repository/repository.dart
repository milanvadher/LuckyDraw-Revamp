import 'package:flutter/foundation.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/repository/coupons_api_provider.dart';
import 'package:lucky_draw_revamp/src/repository/question_api_provider.dart';
import 'auth_api_provider.dart';

class Repository {
  final AuthApiProvider _authApiProvider = AuthApiProvider();
  final CouponsApiProvider _couponApiProvider = CouponsApiProvider();
  final QuestionApiProvider _questionApiProvider = QuestionApiProvider();

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

  // Reset Password
  Future<User> resetPassword({
    @required String mobileNo,
    @required String password,
  }) {
    return _authApiProvider.resetPassword(
      mobileNo: mobileNo,
      password: password,
    );
  }

  // Get user Coupons
  Future getUserCoupons() {
    return _couponApiProvider.getUserCoupons();
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
}
