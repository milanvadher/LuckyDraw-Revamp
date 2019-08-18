class Question {
  List<String> imageList;
  String answer;
  String randomString;

  Question({this.imageList, this.answer, this.randomString});

  Question.fromJson(Map<String, dynamic> json) {
    imageList = json['imageList'].cast<String>();
    answer = json['answer'];
    randomString = json['randomString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageList'] = this.imageList;
    data['answer'] = this.answer;
    data['randomString'] = this.randomString;
    return data;
  }
}
