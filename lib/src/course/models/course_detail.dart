import 'dart:convert';

CourseDetail courseDetailFromJson(String str) => CourseDetail.fromJson(json.decode(str));

String courseDetailToJson(CourseDetail data) => json.encode(data.toJson());

class CourseDetail {
  String model;
  int pk;
  Fields fields;
  List<Session> sessions;

  CourseDetail({
    this.model,
    this.pk,
    this.fields,
    this.sessions,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
    sessions: List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
    "sessions": List<dynamic>.from(sessions.map((x) => x.toJson())),
  };
}

class Fields {
  String courseName;
  String courseDescription;
  DateTime releaseDate;
  List<String> courseCategories;
  List<String> courseAudiences;
  List<DocumentLink> documentLink;
  bool completed;

  Fields({
    this.courseName,
    this.courseDescription,
    this.releaseDate,
    this.courseCategories,
    this.courseAudiences,
    this.documentLink,
    this.completed,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
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

class DocumentLink {
  String name;
  String link;

  DocumentLink({
    this.name,
    this.link,
  });

  factory DocumentLink.fromJson(Map<String, dynamic> json) => DocumentLink(
    name: json["name"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "link": link,
  };
}

class Session {
  int id;
  String sessionName;
  DateTime releaseDate;
  bool completed;
  Session({
    this.id,
    this.sessionName,
    this.releaseDate,
    this.completed
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json["id"],
    sessionName: json["session_name"],
    releaseDate: DateTime.parse(json["release_date"]),
    completed: json["completed"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_name": sessionName,
    "release_date": releaseDate.toIso8601String(),
    "completed": completed
  };
}