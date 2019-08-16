class User {
  int questionState;
  int akQuesSt;
  int points;
  String contactNumber;
  String username;
  bool profile;

  User({
    this.questionState,
    this.akQuesSt,
    this.points,
    this.contactNumber,
    this.username,
    this.profile,
  });

  User.fromJson(Map<String, dynamic> json) {
    questionState = json['questionState'];
    akQuesSt = json['ak_ques_st'];
    points = json['points'];
    contactNumber = json['contactNumber'];
    username = json['username'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionState'] = this.questionState;
    data['ak_ques_st'] = this.akQuesSt;
    data['points'] = this.points;
    data['contactNumber'] = this.contactNumber;
    data['username'] = this.username;
    data['profile'] = this.profile;
    return data;
  }
}
