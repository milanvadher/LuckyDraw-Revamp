import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import '../utils/constant.dart';
import 'package:http/http.dart' show Client;

class AppApi {
  static Client client = Client();

  static Future<Response> postApi({
    @required String apiEndPoint,
    @required Map<String, dynamic> reqData,
    Map<String, String> headers = headers,
  }) async {
    print('reqData fo $apiEndPoint ${reqData.toString()}');
    final response = await client.post(
      '$apiUrl/$apiEndPoint',
      body: json.encode(reqData),
      headers: headers,
    );
    print('Response from $apiEndPoint :: $response');
    return response;
  }

  static Future<Response> getApi({
    @required String apiEndPoint,
    Map<String, String> headers = headers,
  }) async {
    final response = await client.post(
      '$apiUrl/$apiEndPoint',
      headers: headers,
    );
    print('Response from $apiEndPoint :: $response');
    return response;
  }
}
