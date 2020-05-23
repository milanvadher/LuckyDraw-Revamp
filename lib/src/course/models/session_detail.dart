import 'dart:convert';

import 'package:youth_app/src/course/models/course_detail.dart';

SessionDetail sessionDetailFromJson(String str) => SessionDetail.fromJson(json.decode(str));

String sessionDetailToJson(SessionDetail data) => json.encode(data.toJson());

class SessionDetail {
  SessionData session;
  ParentCourse course;

  SessionDetail({
    this.session,
    this.course,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) => SessionDetail(
    session: SessionData.fromJson(json["session"]),
    course: ParentCourse.fromJson(json["course"]),
  );

  Map<String, dynamic> toJson() => {
    "session": session.toJson(),
    "course": course.toJson(),
  };
}

class ParentCourse {
  String model;
  int pk;
  CourseFields fields;
  List<SessionElement> sessions;

  ParentCourse({
    this.model,
    this.pk,
    this.fields,
    this.sessions,
  });

  factory ParentCourse.fromJson(Map<String, dynamic> json) => ParentCourse(
    model: json["model"],
    pk: json["pk"],
    fields: CourseFields.fromJson(json["fields"]),
    sessions: List<SessionElement>.from(json["sessions"].map((x) => SessionElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
    "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
  };
}

class CourseFields {
  String courseName;
  String courseDescription;
  DateTime releaseDate;
  List<String> courseCategories;
  List<String> courseAudiences;
  List<DocumentLink> documentLink;
  bool completed;

  CourseFields({
    this.courseName,
    this.courseDescription,
    this.releaseDate,
    this.courseCategories,
    this.courseAudiences,
    this.documentLink,
    this.completed,
  });

  factory CourseFields.fromJson(Map<String, dynamic> json) => CourseFields(
    courseName: json["course_name"],
    courseDescription: json["course_description"],
    releaseDate: DateTime.parse(json["release_date"]),
    courseCategories: List<String>.from(json["course_categories"].map((x) => x)),
    courseAudiences: List<String>.from(json["course_audiences"].map((x) => x)),
    documentLink: List<DocumentLink>.from(json["document_link"].map((x) => DocumentLink.fromJson(x))),
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "course_name": courseName,
    "course_description": courseDescription,
    "release_date": releaseDate.toIso8601String(),
    "course_categories": List<dynamic>.from(courseCategories.map((x) => x)),
    "course_audiences": List<dynamic>.from(courseAudiences.map((x) => x)),
    "document_link": List<dynamic>.from(documentLink.map((x) => x.toJson())),
    "completed": completed,
  };
}


class SessionElement {
  int id;
  String sessionName;
  DateTime releaseDate;

  SessionElement({
    this.id,
    this.sessionName,
    this.releaseDate,
  });

  factory SessionElement.fromJson(Map<String, dynamic> json) => SessionElement(
    id: json["id"],
    sessionName: json["session_name"],
    releaseDate: DateTime.parse(json["release_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_name": sessionName,
    "release_date": releaseDate.toIso8601String(),
  };
}

class SessionData {
  String model;
  int pk;
  SessionFields fields;
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
    fields: SessionFields.fromJson(json["fields"]),
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class SessionFields {
  List<String> course;
  String sessionName;
  String sessionDescription;
  DateTime releaseDate;
  SessionVideo sessionVideo;
  List<DocumentLink> documentLink;
  bool completed;
  int last_question_attempted;

  SessionFields({
    this.course,
    this.sessionName,
    this.sessionDescription,
    this.releaseDate,
    this.sessionVideo,
    this.documentLink,
    this.completed,
    this.last_question_attempted
  });

  factory SessionFields.fromJson(Map<String, dynamic> json) => SessionFields(
    course: List<String>.from(json["course"].map((x) => x)),
    sessionName: json["session_name"],
    sessionDescription: json["session_description"],
    releaseDate: DateTime.parse(json["release_date"]),
    sessionVideo: SessionVideo.fromJson(json["session_video"]),
    documentLink: List<DocumentLink>.from(json["document_link"].map((x) => DocumentLink.fromJson(x))),
    completed: json["completed"],
    last_question_attempted: json["last_question_attempted"]
  );

  Map<String, dynamic> toJson() => {
    "course": List<dynamic>.from(course.map((x) => x)),
    "session_name": sessionName,
    "session_description": sessionDescription,
    "release_date": releaseDate.toIso8601String(),
    "session_video": sessionVideo.toJson(),
    "document_link": List<dynamic>.from(documentLink.map((x) => x.toJson())),
    "completed": completed,
    "last_question_attempted":last_question_attempted
  };
}

class SessionVideo {
  String videoTitle;
  String videoUrl;

  SessionVideo({
    this.videoTitle,
    this.videoUrl,
  });

  factory SessionVideo.fromJson(Map<String, dynamic> json) {
    if (json == null){
      return null;
    }
    return SessionVideo(

      videoTitle: json["video_title"],
      videoUrl: json["video_url"],
    );
  }

  Map<String, dynamic> toJson() => {
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
