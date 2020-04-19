// To parse this JSON data, do
//
//     final levelLeader = levelLeaderFromJson(jsonString);

import 'dart:convert';

LevelLeaderList levelLeaderFromJson(Map<String, dynamic> decodedJson) {
  print("Inside JSON TO LEADERS");
  return LevelLeaderList.fromJson(decodedJson);
}

String levelLeaderToJson(LevelLeaderList data) => json.encode(data.toJson());

class LevelLeaderList {
  List<LevelLeader> leaders;
  int userRank;

  LevelLeaderList({
    this.leaders,
    this.userRank,
  });

  factory LevelLeaderList.fromJson(Map<String, dynamic> json) =>
      LevelLeaderList(
        leaders:
            List<LevelLeader>.from(json["leaders"].map((x) => LevelLeader.fromJson(x))),
        userRank: json["userRank"],
      );

  Map<String, dynamic> toJson() => {
        "leaders": List<dynamic>.from(leaders.map((x) => x.toJson())),
        "userRank": userRank,
      };
}

class LevelLeader {
  int questionSt;
  int questionReadSt;
  int level;
  int score;
  String name;
  int totalQuestions;
  bool fiftyFifty;
  bool completed;
  String contactNumber;
  AtedAt updatedAt;
  AtedAt createdAt;
  int v;

  LevelLeader({
    this.questionSt,
    this.questionReadSt,
    this.level,
    this.score,
    this.totalQuestions,
    this.fiftyFifty,
    this.completed,
    this.name,
    this.contactNumber,
    this.updatedAt,
    this.createdAt,
    this.v,
  });

  factory LevelLeader.fromJson(Map<String, dynamic> json) => LevelLeader(
        questionSt: json["question_st"],
        questionReadSt: json["question_read_st"],
        level: json["level"],
        score: json["score"],
        name: json["username"],
        totalQuestions: json["total_questions"],
        fiftyFifty: json["fifty_fifty"],
        completed: json["completed"],
        contactNumber: json["contactNumber"],
        updatedAt: AtedAt.fromJson(json["updatedAt"]),
        createdAt: AtedAt.fromJson(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "question_st": questionSt,
        "question_read_st": questionReadSt,
        "level": level,
        "score": score,
        "total_questions": totalQuestions,
        "fifty_fifty": fiftyFifty,
        "completed": completed,
        "username": name,
        "contactNumber": contactNumber,
        "updatedAt": updatedAt.toJson(),
        "createdAt": createdAt.toJson(),
        "__v": v,
      };
}

class AtedAt {
  int date;

  AtedAt({
    this.date,
  });

  factory AtedAt.fromJson(Map<String, dynamic> json) => AtedAt(
        date: json["\u0024date"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024date": date,
      };
}
