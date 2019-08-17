import 'package:lucky_draw_revamp/src/model/coupon.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CouponBloc {
  final repository = Repository();
  final couponFetcher = PublishSubject<Coupon>();

  Observable<Coupon> get couponsList => couponFetcher.stream;

  getUserCoupon() async {
    try {
      Coupon response = await repository.getUserCoupons();
      print('bloc ::: $response');
      couponFetcher.sink.add(response);
    } catch (e) {
      couponFetcher.sink.addError(e);
    }
  }

  dispose() {
    couponFetcher.drain();
  }
}

final bloc = CouponBloc();
