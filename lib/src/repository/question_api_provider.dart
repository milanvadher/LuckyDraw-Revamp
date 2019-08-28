import 'package:flutter/foundation.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/repository/app_api.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';

class QuestionApiProvider {
  Future<Question> getQuestion({@required int questionState}) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'questionState': questionState,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => Question.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'questionDetails',
    );
  }
}
