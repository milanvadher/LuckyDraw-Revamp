class User {
  int questionState;
  int akQuesSt;
  int points;
  String contactNumber;
  String username;
  bool profile;
  List<String> vcCode;

  User({
    this.questionState,
    this.akQuesSt,
    this.points,
    this.contactNumber,
    this.username,
    this.profile,
    this.vcCode,
  });

  User.fromJson(Map<String, dynamic> json) {
    questionState = json['questionState'];
    akQuesSt = json['ak_ques_st'];
    points = json['points'];
    contactNumber = json['contactNumber'];
    username = json['username'];
    profile = json['profile'];
    vcCode = json['vc_code'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionState'] = this.questionState;
    data['ak_ques_st'] = this.akQuesSt;
    data['points'] = this.points;
    data['contactNumber'] = this.contactNumber;
    data['username'] = this.username;
    data['profile'] = this.profile;
    data['vc_code'] = this.vcCode;
    return data;
  }
}
