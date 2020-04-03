import 'package:youth_app/src/model/quizlevel.dart';

class UserState {
  List<QuizLevel> quizLevels;
  List<Current> currentLevels;
  List<CompletedLevel> completed;
  int totalscore;
  int totalscoreMonth;
  int lives;
  int totalscoreWeek;

  UserState({this.quizLevels,
    this.completed,
    this.totalscore,
    this.totalscoreMonth,
    this.lives
  });

  UserState.fromJson(Map<String, dynamic> json) {
    print("==================JSON=====================");
    print(json);
    if (json['quiz_levels'] != null) {
      quizLevels = new List<QuizLevel>();
      json['quiz_levels'].forEach((v) {
        quizLevels.add(new QuizLevel.fromJson(v));
      });
    }
    if (json['completed'] != null) {
      completed = new List<CompletedLevel>();
      json['completed'].forEach((v) {
        completed.add(new CompletedLevel.fromJson(v));
      });
    }
    if (json['current'] != null) {
      currentLevels = new List<Current>();
      json['current'].forEach((v) {
        currentLevels.add(new Current.fromJson(v));
      });
    }
    totalscore = json['totalscore'];
    totalscoreMonth = json['totalscore_month'];
    totalscoreWeek = json['totalscore_week'];
    lives = json['lives'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.quizLevels != null) {
      data['quiz_levels'] = this.quizLevels.map((v) => v.toJson()).toList();
    }
    if (this.completed != null) {
      data['completed'] = this.completed.map((v) => v.toJson()).toList();
    }
    data['totalscore'] = this.totalscore;
    data['totalscore_month'] = this.totalscoreMonth;
    data['totalscore_week'] = this.totalscoreWeek;
    data['lives'] = this.lives;
    return data;
  }
}

class CompletedLevel {
  int level;
  int score;

  CompletedLevel({this.level, this.score});

  CompletedLevel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['score'] = this.score;
    return data;
  }

  @override
  String toString() {
    return 'CompletedLevel{level: $level, score: $score}';
  }
}

class Current {
  int level;
  int questionSt;

  Current({this.level, this.questionSt});

  Current.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    questionSt = json['question_st'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['question_st'] = this.questionSt;
    return data;
  }

  @override
  String toString() {
    return 'Current{level: $level, score: $questionSt}';
  }
}
