import 'dart:convert';
import '../utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiProvider {
  Client client = Client();

  Future login({
    @required String mobileNo,
    @required String password,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'password': password
    };
    final response = await client.post(
      '$apiUrl/login',
      body: json.encode(reqData),
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('login data ${response.body}');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('$userDataKey', response.body);
    }
    throw json.decode(response.body)['err'] ?? 'Error to Login';
  }
  
  Future sendOtp({
    @required String mobileNo,
    @required int otp,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': mobileNo,
      'otp': otp
    };
    final response = await client.post(
      '$apiUrl/otp',
      body: json.encode(reqData),
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('otp data ${response.body}');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('$userDataKey', response.body);
    }
    throw json.decode(response.body)['err'] ?? 'Error to Login';
  }
}
