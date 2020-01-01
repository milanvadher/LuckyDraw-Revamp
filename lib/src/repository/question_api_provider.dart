import 'package:flutter/foundation.dart';
import 'package:youth_app/src/model/ay_question.dart';
import 'package:youth_app/src/model/question.dart';
import 'package:youth_app/src/model/user_level.dart';
import 'package:youth_app/src/model/validate_answer.dart';
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
      isAYApi: true,
    );
  }

  Future<UserLevel> checkUserLevel({@required int levelIndex}) async {
    Map<String, dynamic> reqData = {
      'mht_id': CacheData.userInfo.contactNumber,
      'level': levelIndex
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => UserLevel.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'check_user_level',
      isAYApi: true,
    );
  }

  Future<List<AYQuestion>> getAllQuestions({
    @required int levelIndex,
    @required int from,
  }) async {
    Map<String, dynamic> reqData = {
      'level': levelIndex,
      'QuestionFrom': from,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => AYQuestion.fromJsonArray(json['data']),
      reqData: reqData,
      apiEndPoint: 'questions',
      isAYApi: true,
      isFromResult: false,
    );
  }

  Future<ValidateAnswer> validateAnswer({
    @required int questionId,
    @required String answer,
    @required int level,
  }) async {
    Map<String, dynamic> reqData = {
      "question_id": questionId,
      "mht_id": CacheData.userInfo.contactNumber,
      "answer": answer,
      "level": level
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => ValidateAnswer.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'validate_answer',
      isAYApi: true,
      isFromResult: false,
    );
  }
}
