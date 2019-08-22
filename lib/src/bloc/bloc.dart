import 'package:flutter/widgets.dart';
import 'package:lucky_draw_revamp/src/model/coupon.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class Bloc {
  final repository = Repository();
  final couponFetcher = PublishSubject<Coupon>();
  final questionFetcher = PublishSubject<Question>();

  Observable<Coupon> get couponsList => couponFetcher.stream;
  Observable<Question> get question => questionFetcher.stream;

  getUserCoupon() async {
    try {
      Coupon response = await repository.getUserCoupons();
      print('bloc ::: $response');
      couponFetcher.sink.add(response);
    } catch (e) {
      couponFetcher.sink.addError(e);
    }
  }

  getQuestion({@required int questionState}) async {
    try {
      Question response = await repository.getQuestion(
        questionState: questionState,
      );
      print('Question :: $response');
      questionFetcher.sink.add(response);
    } catch (e) {
      questionFetcher.sink.addError(e);
    }
  }

  dispose() {
    couponFetcher.drain();
    questionFetcher.drain();
  }
}

final bloc = Bloc();
