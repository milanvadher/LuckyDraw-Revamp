import '../utils/cachedata.dart';
import '../utils/points.dart';

class ValidateAnswer {
  bool answerStatus;
  int totalscoreMonth;
  int questionSt;
  int questionReadSt;

  ValidateAnswer({this.answerStatus});

  ValidateAnswer.fromJson(Map<String, dynamic> json) {
    answerStatus = json['answer_status'];
    totalscoreMonth = json['totalscore_month'];
    questionSt = json['question_st'];
    questionReadSt = json['question_read_st'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_status'] = this.answerStatus;
    data['totalscore_month'] = this.totalscoreMonth;
    data['question_st'] = this.questionSt;
    data['question_read_st'] = this.questionReadSt;
    return data;
  }

  updateSessionScore() {
    if (totalscoreMonth != null)
      CacheData.userState.totalscore = totalscoreMonth;
      Point.updatePoint();
  }
}
