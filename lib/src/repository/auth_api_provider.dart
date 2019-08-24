import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import '../utils/constant.dart';
import 'package:http/http.dart' show Client;

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
    final response = await client.post(
      '$apiUrl/login',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('login data ${response.body}');
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
    final response = await client.post(
      '$apiUrl/profileUpdate',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('edit data ${response.body}');
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
    final response = await client.post(
      '$apiUrl/otp',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('otp data ${response.body}');
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
    final response = await client.post(
      '$apiUrl/register',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('register data ${response.body}');
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
    final response = await client.post(
      '$apiUrl/forgotPassword',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('forgotPassword data ${response.body}');
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
    final response = await client.post(
      '$apiUrl/saveUserData',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('saveUserData ${response.body}');
      await Config.saveObjectJson('$userDataKey', json.decode(response.body));
      return User.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Save User Data';
  }
}
