class SubscriptionModel {
  String username;
  bool isEmail;
  bool isSMS;
  String firebasetoken;
  String contactNumber;
  String email;

  SubscriptionModel({
    this.username,
    this.isEmail,
    this.isSMS,
    this.firebasetoken,
    this.contactNumber,
    this.email,
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    isEmail = json['isEmail'];
    isSMS = json['isSMS'];
    firebasetoken = json['firebasetoken'];
    contactNumber = json['contactNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['isEmail'] = this.isEmail;
    data['isSMS'] = this.isSMS;
    data['firebasetoken'] = this.firebasetoken;
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
    return data;
  }
}
