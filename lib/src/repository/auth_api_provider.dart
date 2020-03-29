import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:youth_app/src/model/subscription.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'app_api.dart';

class AuthApiProvider {
  Client client = Client();

  Future<User> login({
    @required String mobileNo,
    @required String password,
    bool isAYApi = false,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'password': password,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'login',
      isAYApi: isAYApi,
    );
  }

  Future<UserState> loadUserState({
    @required String mobileNo,
    @required int category,
    bool isAYApi = true,
  }) async {
    Map<String, dynamic> reqData = {'mht_id': mobileNo, 'category': category};
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => UserState.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'user_state',
      isAYApi: isAYApi,
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

  Future<User> saveUserData(
      {@required int points,
      @required int questionState,
      String firebaseToken}) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'points': points,
      'questionState': questionState,
      'firebasetoken': firebaseToken
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => User.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'saveUserData',
    );
  }

  static dynamic tryDecode(String jsonStr) {
    try {
      return json.decode(jsonStr);
    } catch (e) {
      return null;
    }
  }

  Future<SubscriptionModel> subscription(
      {@required String contactNumber,
      String email,
      String username,
      bool isEmail,
      bool isSMS,
      String firebasetoken}) async {
    Map<String, dynamic> reqData = {
      'username': username,
      'isEmail': isEmail,
      'isSMS': isSMS,
      'firebasetoken': firebasetoken,
      'contactNumber': contactNumber,
      'email': email
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => SubscriptionModel.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'subscription',
    );
  }
}
