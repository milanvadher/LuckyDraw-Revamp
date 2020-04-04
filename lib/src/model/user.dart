class User {
  int questionState;
  int points;
  String contactNumber;
  String username;
  bool profile;
  int role;

  User(
      {this.questionState,
      this.points,
      this.contactNumber,
      this.username,
      this.profile,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    questionState = json['questionState'];
    points = json['points'];
    contactNumber = json['contactNumber'];
    username = json['username'];
    profile = json['profile'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionState'] = this.questionState;
    data['points'] = this.points;
    data['contactNumber'] = this.contactNumber;
    data['username'] = this.username;
    data['profile'] = this.profile;
    data['role'] = this.role;
    return data;
  }
}
