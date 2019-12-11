import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:youth_app/src/model/leaders.dart';
import 'package:youth_app/src/repository/app_api.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/constant.dart';

class LeadersApiProvider {
  Client client = Client();

  Future<LeaderList> getLeaders() async {
    Map<String, Map<String, dynamic>> reqData = {
      'params': {'contactNumber': CacheData.userInfo?.contactNumber}
    };
    return await AppApi.getApiWithParseRes(
        fromJson: (json) => LeaderList.fromJson(json),
        params: reqData,
        apiEndPoint: 'leaders',
        isAYApi: true);
  }
}
