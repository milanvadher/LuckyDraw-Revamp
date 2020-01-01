import 'package:flutter/widgets.dart';
import 'package:youth_app/src/model/coupon.dart';
import 'package:youth_app/src/model/leaders.dart';
import 'package:youth_app/src/model/question.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class Bloc {
  final repository = Repository();
  final couponFetcher = PublishSubject<Coupon>();
  final questionFetcher = PublishSubject<Question>();
  final leadersFetcher = PublishSubject<LeaderList>();

  Observable<LeaderList> get leadersList => leadersFetcher.stream;
  Observable<Coupon> get couponsList => couponFetcher.stream;
  Observable<Question> get question => questionFetcher.stream;

  getLeaderboard() async {
    try {
      LeaderList response = await repository.getLeaders();
      print('bloc ::: $response');
      leadersFetcher.sink.add(response);
    } catch (e) {
      leadersFetcher.sink.addError(e);
    }
  }

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
    leadersFetcher.drain();
  }
}

final bloc = Bloc();
