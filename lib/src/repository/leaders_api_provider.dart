import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:youth_app/src/model/leaders.dart';
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
}
