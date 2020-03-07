class SubscriptionModel {
  String contactNumber;
  String email;

  SubscriptionModel({
    this.contactNumber,
    this.email,
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    contactNumber = json['contactNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
    return data;
  }
}
