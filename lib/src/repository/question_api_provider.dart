import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/repository/app_api.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';

class QuestionApiProvider {
  Future<Question> getQuestion({@required int questionState}) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'questionState': questionState,
    };
    Response response = await AppApi.postApi(
      apiEndPoint: 'questionDetails',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      return Question.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Get Question';
  }
}
