import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';
import '../utils/constant.dart';
import 'package:http/http.dart' show Client;

class AppApi {
  static Client client = Client();

  static Future<dynamic> postApiWithParseRes({
    @required String apiEndPoint,
    @required Map<String, dynamic> reqData,
    @required Function fromJson,
    Map<String, String> headers = headers,
    bool throwError = true,
  }) async {
    try {
      Response response = await AppApi.postApi(
        apiEndPoint: apiEndPoint,
        reqData: reqData,
      );
      if (response.statusCode == 200) {
        return fromJson(json.decode(response.body));
      }
      if (throwError) {
        var decodedJson = tryDecode(response.body);
        throw decodedJson != null
            ? (decodedJson['err'] ?? '$defaultError')
            : '$defaultError';
      }
    } on SocketException {
      throw 'Please connect Internet';
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getApiWithParseRes({
    @required String apiEndPoint,
    @required Function fromJson,
    Map<String, String> headers = headers,
    bool throwError = true,
  }) async {
    try {
      Response response = await AppApi.getApi(
        apiEndPoint: apiEndPoint,
      );
      if (response.statusCode == 200) {
        return fromJson(json.decode(response.body));
      }
      if (throwError) {
        var decodedJson = tryDecode(response.body);
        throw decodedJson != null
            ? (decodedJson['err'] ?? '$defaultError')
            : '$defaultError';
      }
    } on SocketException {
      throw 'Please connect Internet';
    } catch (e) {
      throw e;
    }
  }

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
    print('Response from $apiEndPoint :: ${response.body}');
    return response;
  }

  static Future<Response> getApi({
    @required String apiEndPoint,
    Map<String, String> headers = headers,
  }) async {
    print('Start calling ... /$apiEndPoint');
    final response = await client.get(
      '$apiUrl/$apiEndPoint',
      headers: headers,
    );
    print(
        'Response from $apiEndPoint :: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
    return response;
  }

  static dynamic tryDecode(String jsonStr) {
    try {
      return json.decode(jsonStr);
    } catch (e) {
      return null;
    }
  }
}
