import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:lucky_draw_revamp/src/model/coupon.dart';
import 'package:lucky_draw_revamp/src/repository/app_api.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';

class CouponsApiProvider {
  Future<Coupon> getUserCoupons() async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
    };
    Response response = await AppApi.postApi(
      apiEndPoint: 'getUserTickets',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      return Coupon.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Get User coupons';
  }

  Future<String> generateCoupon({
    @required int questionState,
  }) async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
      'questionState': questionState,
    };
    Response response = await AppApi.postApi(
      apiEndPoint: 'generateTicket',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['msg'];
    }
    throw json.decode(response.body)['err'] ?? 'Error to Generate coupon';
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
    Response response = await AppApi.postApi(
      apiEndPoint: 'mapTicket',
      reqData: reqData,
    );
    if (response.statusCode == 200) {
      return Coupon.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Assign coupon';
  }
}
