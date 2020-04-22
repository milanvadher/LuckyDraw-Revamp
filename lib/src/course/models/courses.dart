// To parse this JSON data, do
//
//     final courses = coursesFromJson(jsonString);

import 'dart:convert';

//Courses coursesFromJson(String str) => Courses.fromJson(json.decode(str));
//
//String coursesToJson(Courses data) => json.encode(data.toJson());
//
//class Courses {
//  List<Course> courses;
//
//  Courses({
//    this.courses,
//  });
//
//  factory Courses.fromJson(List<Map<String, dynamic>> json) => Courses(
//    courses: List<Course>.from(json.map((x) => Course.fromJson(x))),
//  );
//
//  List<Map<String, dynamic>> toJson() =>
//    List<dynamic>.from(courses.map((x) => x.toJson()));
//
//}

class Course {
  String model;
  int pk;
  Fields fields;

  Course({
    this.model,
    this.pk,
    this.fields,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  String courseName;
  String courseDescription;
  DateTime releaseDate;
  List<String> courseCategories;
  List<String> courseAudiences;
  List<List<String>> documentLink;

  Fields({
    this.courseName,
    this.courseDescription,
    this.releaseDate,
    this.courseCategories,
    this.courseAudiences,
    this.documentLink,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    courseName: json["course_name"],
    courseDescription: json["course_description"],
    releaseDate: DateTime.parse(json["release_date"]),
    courseCategories: List<String>.from(json["course_categories"].map((x) => x)),
    courseAudiences: List<String>.from(json["course_audiences"].map((x) => x)),
    documentLink: List<List<String>>.from(json["document_link"].map((x) => List<String>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "course_name": courseName,
    "course_description": courseDescription,
    "release_date": releaseDate.toIso8601String(),
    "course_categories": List<dynamic>.from(courseCategories.map((x) => x)),
    "course_audiences": List<dynamic>.from(courseAudiences.map((x) => x)),
    "document_link": List<dynamic>.from(documentLink.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}
