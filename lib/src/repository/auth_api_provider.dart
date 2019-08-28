import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'app_api.dart';

class AuthApiProvider {
  Client client = Client();

  Future<User> login({
    @required String mobileNo,
    @required String password,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'password': password,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'login',
    );
  }

  Future<User> editUser({
    @required String mobileNo,
    @required String username,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'username': username,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'profileUpdate',
    );
  }

  Future<bool> sendOtp({
    @required String mobileNo,
    @required int otp,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'otp': otp,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => json['isNewUser'],
      reqData: reqData,
      apiEndPoint: 'otp',
    );
  }

  Future<User> registerUser({
    @required String username,
    @required String mobileNo,
    @required String password,
  }) async {
    Map<String, dynamic> reqData = {
      'username': username,
      'contactNumber': mobileNo,
      'password': password,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'register',
    );
  }

  Future<User> resetPassword({
    @required String mobileNo,
    @required String password,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'password': password,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'forgotPassword',
    );
  }

  Future<User> saveUserData({
    @required int points,
    @required int questionState,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'points': points,
      'questionState': questionState,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'saveUserData',
    );
  }
}
