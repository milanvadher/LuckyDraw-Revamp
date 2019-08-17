class User {
  int questionState;
  int points;
  String contactNumber;
  String username;
  bool profile;

  User({
    this.questionState,
    this.points,
    this.contactNumber,
    this.username,
    this.profile,
  });

  User.fromJson(Map<String, dynamic> json) {
    questionState = json['questionState'];
    points = json['points'];
    contactNumber = json['contactNumber'];
    username = json['username'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionState'] = this.questionState;
    data['points'] = this.points;
    data['contactNumber'] = this.contactNumber;
    data['username'] = this.username;
    data['profile'] = this.profile;
    return data;
  }
}
