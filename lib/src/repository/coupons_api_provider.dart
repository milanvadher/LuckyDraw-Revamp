import 'package:flutter/foundation.dart';
import 'package:youth_app/src/model/coupon.dart';
import 'package:youth_app/src/repository/app_api.dart';
import 'package:youth_app/src/utils/cachedata.dart';

class CouponsApiProvider {
  Future<Coupon> getUserCoupons() async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => Coupon.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'getUserTickets',
    );
  }

  Future<String> generateCoupon({
    @required int questionState,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'questionState': questionState,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => json['msg'],
      reqData: reqData,
      apiEndPoint: 'generateTicket',
    );
  }

  Future<Coupon> assignCoupon({
    @required int coupon,
    @required List<int> date,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'ticket': coupon,
      'date': date,
    };
    return await AppApi.postApiWithParseRes(
      fromJson: (json) => Coupon.fromJson(json),
      reqData: reqData,
      apiEndPoint: 'mapTicket',
    );
  }
}
