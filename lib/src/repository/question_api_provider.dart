import 'package:flutter/foundation.dart';
import 'package:youth_app/src/model/question.dart';
import 'package:youth_app/src/repository/app_api.dart';
import 'package:youth_app/src/utils/cachedata.dart';

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
