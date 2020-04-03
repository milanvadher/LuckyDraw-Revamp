import '../utils/cachedata.dart';
import '../utils/points.dart';

class ValidateAnswer {
  bool answerStatus;
  int totalscoreMonth;
  int questionSt;
  int questionReadSt;
  int totalscoreWeek;

  ValidateAnswer({this.answerStatus});

  ValidateAnswer.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    print(json);
    answerStatus = json['answer_status'];
    totalscoreMonth = json['totalscore_month'];
    questionSt = json['question_st'];
    questionReadSt = json['question_read_st'];
    totalscoreWeek = json['totalscore_week'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_status'] = this.answerStatus;
    data['totalscore_month'] = this.totalscoreMonth;
    data['question_st'] = this.questionSt;
    data['question_read_st'] = this.questionReadSt;
    data['totalscore_week'] = this.totalscoreWeek;
    return data;
  }

  updateSessionScore({int categoryNumber = 1}) {
    if (totalscoreMonth != null)
      CacheData.userState.totalscore = totalscoreMonth + totalscoreWeek;   // Please verify this
      Point.updatePoint(categoryNumber: categoryNumber);
  }
}
