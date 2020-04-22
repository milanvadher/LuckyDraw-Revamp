import 'dart:convert';

import 'package:youth_app/src/course/models/course_detail.dart';
import 'package:youth_app/src/course/models/courses.dart';
import 'package:http/http.dart' as http;
import 'package:youth_app/src/course/models/session_detail.dart';
import 'package:youth_app/src/utils/constant.dart';

class CourseService {
  Future<List<Course>> getCourseList() async {
    final response = await http.get(courseUrl + "/course/api/index");
    var courseJson = json.decode(response.body);
    return List<Course>.from(courseJson.map((x) => Course.fromJson(x)));
  }

  Future<CourseDetail> getCourseById(int pk) async {
    final response = await http.get(courseUrl + "/course/api/" + pk.toString());
    var courseJson = json.decode(response.body);
    return CourseDetail.fromJson(courseJson);
  }

  Future<SessionDetail> getSessionById(int courseId, int sessionId) async {
    final response = await http.get(courseUrl +
        "/course/api/" +
        courseId.toString() +
        "/" +
        sessionId.toString());
    var sessionJson = json.decode(response.body);
    return SessionDetail.fromJson(sessionJson);
  }
}
