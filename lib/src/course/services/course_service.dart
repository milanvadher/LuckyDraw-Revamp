import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_app/src/course/models/course_detail.dart';
import 'package:youth_app/src/course/models/courses.dart';
import 'package:http/http.dart' as http;
import 'package:youth_app/src/course/models/session_detail.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/constant.dart';

class CourseService {
  String csrfToken;
  CourseService() {}

  Future<String> _getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("csrf");
    // print("token fetched------- $token");
    return token;
  }

  String _getPhoneNumber() {
    // print("phobe bunver-------------");
    // print(CacheData.userInfo.contactNumber);
    return CacheData.userInfo.contactNumber;
    // return "1234";
  }

  Future<List<Course>> getCourseList() async {
    final response = await http.post(courseUrl + "/course/api/index",
        body: {"ph_num": _getPhoneNumber()});
    var courseJson = json.decode(response.body);
    return List<Course>.from(courseJson.map((x) => Course.fromJson(x)));
  }

  Future<CourseDetail> getCourseById(int pk) async {
    final response = await http.post(courseUrl + "/course/api/" + pk.toString(),
        // headers: {"X-CSRFToken": await _getToken()},
        body: {"ph_num": _getPhoneNumber()});
    print(response.body);
    var courseJson = json.decode(response.body);
    return CourseDetail.fromJson(courseJson);
  }

  Future<SessionDetail> getSessionById(int courseId, int sessionId) async {
    final response = await http.post(
        courseUrl +
            "/course/api/" +
            courseId.toString() +
            "/" +
            sessionId.toString(),
        body: {"ph_num": _getPhoneNumber()});
    var sessionJson = json.decode(response.body);
    // print(response.body);
    return SessionDetail.fromJson(sessionJson);
  }

  questionAttempted(int sessionId, int questionId) {
    http.post(courseUrl + "/progress/api/question_attempted", body: {
      "question_id": questionId.toString(),
      "session_id": sessionId.toString(),
      "ph_num": _getPhoneNumber()
    });
  }

  statisticQuestionUpdate(Map<String, dynamic> quesdata) async {
    quesdata["ph_num"] = _getPhoneNumber();
    print(quesdata);
    final response = await http.post(
      courseUrl + "/statistics/course/session_update",
      // body: json.encode(quesdata));
      body: json.encode(quesdata),
    );
    print("status code");
    print(response.statusCode);
    print(response.body);
  }

  statisticVideoUpdate(int session_id) async {
    Map<String, dynamic> data = {
      "session_id": session_id,
      "video_completed": true,
      "questions": []
    };
    final response = await http.post(
        courseUrl + "/statistics/course/session_update",
        body: json.encode(data));
    print("stat video update");
    print(response.statusCode);
  }

  sessionComplete(int sessionId) async {
    print("Making SEssion Complete request");
    final response =
        await http.post(courseUrl + "/progress/api/session_complete", body: {
      "session_id": sessionId.toString(),
      "complete": "true",
      "ph_num": _getPhoneNumber()
    });
  }

  Future<String> getCsrfToken() async {
    final response = await http.get(courseUrl + "/core/get_token");
    String token = response.headers["x-csrftoken"];
    return token;
  }
}
