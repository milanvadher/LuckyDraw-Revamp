import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> notifyMe(String name, String number) async {
  final response = await http.get(Uri.parse(
      "https://youth.dadabhagwan.org/umbraco/Surface/YouthSurface/AddAYSubscriber?FullName=" +
          name +
          "&WANumber=" +
          number));
  print(response.statusCode);
  if (response.statusCode == 200) {
    if (response.body.toString() == (-1).toString())
      print("User Already Registered !!!");
    if (response.body.toString() == (1).toString())
      print("New User Registered !!!");
    return response.body;
  } else {
    throw Exception('Failed to load users');
  }
}
