import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:youth_app/src/model/leaders.dart';
import 'package:youth_app/src/repository/app_api.dart';
import 'package:youth_app/src/utils/cachedata.dart';

class LeadersApiProvider {
  Client client = Client();

  Future<LeaderList> getLeaders() async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => LeaderList.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'leaders_month',
      isAYApi: true
    );
  }
}
