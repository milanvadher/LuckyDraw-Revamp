import 'dart:convert';

Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  int pk;
  String courseName;
  String courseDescription;
  DateTime releaseDate;
  List<String> courseCategories;
  List<String> courseAudiences;
  bool completed;

  Course({
    this.pk,
    this.courseName,
    this.courseDescription,
    this.releaseDate,
    this.courseCategories,
    this.courseAudiences,
    this.completed
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    pk: json["pk"],
    courseName: json["course_name"],
    courseDescription: json["course_description"],
    releaseDate: DateTime.parse(json["release_date"]),
    courseCategories: List<String>.from(json["course_categories"].map((x) => x)),
    courseAudiences: List<String>.from(json["course_audiences"].map((x) => x)),
    completed: json["completed"]
  );

  Map<String, dynamic> toJson() => {
    "pk": pk,
    "course_name": courseName,
    "course_description": courseDescription,
    "release_date": releaseDate.toIso8601String(),
    "course_categories": List<dynamic>.from(courseCategories.map((x) => x)),
    "course_audiences": List<dynamic>.from(courseAudiences.map((x) => x)),
    "completed": completed
  };
}
