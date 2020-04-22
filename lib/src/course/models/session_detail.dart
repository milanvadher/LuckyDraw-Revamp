import 'dart:convert';
import 'package:youth_app/src/course/models/courses.dart';

SessionDetail sessionDetailFromJson(String str) => SessionDetail.fromJson(json.decode(str));

String sessionDetailToJson(SessionDetail data) => json.encode(data.toJson());

class SessionDetail {
  SessionData session;
  Course course;

  SessionDetail({
    this.session,
    this.course,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) => SessionDetail(
    session: SessionData.fromJson(json["session"]),
    course: Course.fromJson(json["course"]),
  );

  Map<String, dynamic> toJson() => {
    "session": session.toJson(),
    "course": course.toJson(),
  };
}


class SessionData {
  String model;
  int pk;
  Fields fields;
  List<Question> questions;

  SessionData({
    this.model,
    this.pk,
    this.fields,
    this.questions,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Fields {
  List<String> course;
  String sessionName;
  String sessionDescription;
  DateTime releaseDate;
  SessionVideo sessionVideo;
  List<List<String>> documentLink;

  Fields({
    this.course,
    this.sessionName,
    this.sessionDescription,
    this.releaseDate,
    this.sessionVideo,
    this.documentLink,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    course: List<String>.from(json["course"].map((x) => x)),
    sessionName: json["session_name"],
    sessionDescription: json["session_description"],
    releaseDate: DateTime.parse(json["release_date"]),
    sessionVideo: SessionVideo.fromJson(json["session_video"]),
    documentLink: List<List<String>>.from(json["document_link"].map((x) => List<String>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "course": List<dynamic>.from(course.map((x) => x)),
    "session_name": sessionName,
    "session_description": sessionDescription,
    "release_date": releaseDate.toIso8601String(),
    "session_video": sessionVideo,
    "document_link": List<dynamic>.from(documentLink.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}

class SessionVideo {
  String videoTitle;
  String videoUrl;

  SessionVideo({
    this.videoTitle,
    this.videoUrl,
  });

  factory SessionVideo.fromJson(Map<String, dynamic> json){
    if(json == null){
      return null;
    }
    return SessionVideo(
        videoTitle: json["video_title"],
        videoUrl: json["video_url"],
      );
  }

  Map<String, dynamic> toJson() =>
      {
        "video_title": videoTitle,
        "video_url": videoUrl,
      };
}
class Question {
  int id;
  String questionText;
  List<Choice> choices;

  Question({
    this.id,
    this.questionText,
    this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    questionText: json["question_text"],
    choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_text": questionText,
    "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
  };
}

class Choice {
  int id;
  String choiceText;
  bool isAnswer;

  Choice({
    this.id,
    this.choiceText,
    this.isAnswer,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
    id: json["id"],
    choiceText: json["choice_text"],
    isAnswer: json["is_answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "choice_text": choiceText,
    "is_answer": isAnswer,
  };
}
