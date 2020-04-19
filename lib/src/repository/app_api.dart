import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:youth_app/src/utils/constant.dart';
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
    bool isAYApi = false,
    bool isFromResult = true,
  }) async {
    try {
      Response response = await AppApi.postApi(
        apiEndPoint: apiEndPoint,
        reqData: reqData,
        isAYapi: isAYApi,
      );
      if (response.statusCode == 200) {
        if (isAYApi) {
          if (isFromResult) {
            return fromJson(json.decode(response.body)['data']['results']);
          }
          return fromJson(json.decode(response.body));
        }
        print(fromJson(json.decode(response.body)));
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
    bool isAYApi = false,
    Map<String, String> params,
  }) async {
    try {
      Response response = await AppApi.getApi(
          apiEndPoint: apiEndPoint, isAYapi: isAYApi, params: params);
      if (response.statusCode == 200) {
        if (isAYApi) {
          return fromJson(json.decode(response.body)['data']);
        }
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
    bool isAYapi = false,
  }) async {
    print('reqData fo $apiEndPoint ${reqData.toString()}');
    String postURL =
        isAYapi ? '$ayApiUrl/$apiEndPoint' : '$apiUrl/$apiEndPoint';
    final response = await client.post(
      postURL,
      body: json.encode(reqData),
      headers: headers,
    );
    print('Response from $apiEndPoint :: ${response.body}');
    return response;
  }

  static Future<Response> getApi({
    @required String apiEndPoint,
    Map<String, String> headers = headers,
    bool isAYapi = false,
    Map<String, String> params,
  }) async {
    print('Start calling ... /$apiEndPoint');

    Map<String, String> allHeader;
    if (params == null) {
      allHeader = {}..addAll(headers);
    } else {
      allHeader = {}..addAll(headers)..addAll(params);
    }
    print('This is All Headers ... $allHeader');

    String postURL =
        isAYapi ? '$ayApiUrl/$apiEndPoint' : '$apiUrl/$apiEndPoint';

    print('This is the URL ... $postURL');

    final response = await client.get(
      postURL,
      headers: allHeader,
    );
    print(response);
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
