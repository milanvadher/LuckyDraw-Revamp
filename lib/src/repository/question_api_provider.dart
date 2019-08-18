import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import '../utils/constant.dart';
import 'package:http/http.dart' show Client;

class QuestionApiProvider {
  Client client = Client();

  Future<Question> getQuestion({@required int questionState}) async {
    Map<String, dynamic> reqData = {
      'questionState': questionState,
    };
    final response = await client.post(
      '$apiUrl/questionDetails',
      body: json.encode(reqData),
      headers: headers,
    );
    if (response.statusCode == 200) {
      debugPrint('questionDetails ${response.body}');
      return Question.fromJson(json.decode(response.body));
    }
    throw json.decode(response.body)['err'] ?? 'Error to Get Question';
  }
}
