class UserLevel {
  int questionSt;
  int questionReadSt;
  int level;
  int score;
  int totalQuestions;
  bool fiftyFifty;
  bool completed;
  int mhtId;
  String updatedAt;
  String createdAt;

  UserLevel(
      {this.questionSt,
      this.questionReadSt,
      this.level,
      this.score,
      this.totalQuestions,
      this.fiftyFifty,
      this.completed,
      this.mhtId,
      this.updatedAt,
      this.createdAt});

  UserLevel.fromJson(Map<String, dynamic> json) {
    questionSt = json['question_st'];
    questionReadSt = json['question_read_st'];
    level = json['level'];
    score = json['score'];
    totalQuestions = json['total_questions'];
    fiftyFifty = json['fifty_fifty'];
    completed = json['completed'];
    mhtId = json['mht_id'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_st'] = this.questionSt;
    data['question_read_st'] = this.questionReadSt;
    data['level'] = this.level;
    data['score'] = this.score;
    data['total_questions'] = this.totalQuestions;
    data['fifty_fifty'] = this.fiftyFifty;
    data['completed'] = this.completed;
    data['mht_id'] = this.mhtId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
