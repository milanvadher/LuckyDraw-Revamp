import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lucky_draw_revamp/src/model/coupon.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import '../utils/constant.dart';
import 'package:http/http.dart' show Client;

class CouponsApiProvider {
  Client client = Client();

  Future<Coupon> getUserCoupons() async {
    Map<String, dynamic> reqData = {
      'contactNumber': CacheData.userInfo?.contactNumber,
    };
    final response = await client.post(
      '$apiUrl/getUserTickets',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('getUserTickets ${response.body}');
      return Coupon.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Get User coupons';
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
    final response = await client.post(
      '$apiUrl/mapTicket',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('mapTicket ${response.body}');
      return Coupon.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Assign coupon';
  }
}
