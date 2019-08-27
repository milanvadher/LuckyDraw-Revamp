import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import '../utils/constant.dart';
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
    Response response = await AppApi.postApi(
      apiEndPoint: 'login',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      await Config.saveObjectJson('$userDataKey', json.decode(response.body));
      return User.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Login';
  }
  
  Future<User> editUser({
    @required String mobileNo,
    @required String username,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'username': username,
    };
    Response response = await AppApi.postApi(
      apiEndPoint: 'profileUpdate',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      await Config.saveObjectJson('$userDataKey', json.decode(response.body));
      return User.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Edit User';
  }

  Future<bool> sendOtp({
    @required String mobileNo,
    @required int otp,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'otp': otp,
    };
    Response response = await AppApi.postApi(
      apiEndPoint: 'otp',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['isNewUser'];
    }
    throw json.decode(response.body)['err'] ?? 'Error to Send OTP';
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
    Response response = await AppApi.postApi(
      apiEndPoint: 'register',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      await Config.saveObjectJson('$userDataKey', json.decode(response.body));
      return User.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Register';
  }

  Future<User> resetPassword({
    @required String mobileNo,
    @required String password,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'password': password,
    };
    Response response = await AppApi.postApi(
      apiEndPoint: 'forgotPassword',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      await Config.saveObjectJson('$userDataKey', json.decode(response.body));
      return User.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Reset Password';
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
    Response response = await AppApi.postApi(
      apiEndPoint: 'saveUserData',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      await Config.saveObjectJson('$userDataKey', json.decode(response.body));
      return User.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Save User Data';
  }
}
