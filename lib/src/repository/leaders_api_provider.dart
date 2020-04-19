import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:youth_app/src/model/leaders.dart';
import 'package:youth_app/src/model/level_leader.dart';
import 'package:youth_app/src/repository/app_api.dart';
import 'package:youth_app/src/utils/cachedata.dart';

class LeadersApiProvider {
  Client client = Client();

  Future<LeaderList> getLeaders(int categoryNumber) async {
    Map<String, String> reqData = {
      'mht_id': CacheData.userInfo?.contactNumber,
      'category': categoryNumber.toString()
    };
    return await AppApi.getApiWithParseRes(
        fromJson: (json) => LeaderList.fromJson(json),
        params: reqData,
        apiEndPoint: 'leaders',
        isAYApi: true);
  }

  Future<LevelLeaderList> getLeveleaders(int levelNumber) async {
    Map<String, dynamic> reqData = {
      'level': levelNumber,
      'mht_id': CacheData.userInfo?.contactNumber.toString()
    };
    return await AppApi.postApiWithParseRes(
        fromJson: (json) => levelLeaderFromJson(json),
        reqData: reqData,
        apiEndPoint: 'level_wise_leaders',
        isAYApi: false,

    );
  }
}
