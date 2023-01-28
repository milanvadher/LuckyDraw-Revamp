import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchUsers() async {
  final response =
      await http.get(Uri.parse("http://youthapi.dbf.ooo:8081/youth_app_menu"));
  if (response.statusCode == 200) {
    var getUsersData = json.decode(response.body) as List;
    List<dynamic> listUsers =
        getUsersData.map((i) => MenuApi.fromJSON(i)).toList();
    return listUsers;
  } else {
    throw Exception('Failed to load users');
  }
}

class MenuApi {
  String? menuTitle;
  String? menuLink;
  String? menuImage;

  MenuApi({this.menuTitle, this.menuLink, this.menuImage});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_title'] = this.menuTitle;
    data['menu_link'] = this.menuLink;
    data['menu_image'] = this.menuImage;
    return data;
  }

  static fromJSON(Map<String, dynamic> json) {
    return MenuApi(
        menuTitle: json['menu_title'],
        menuLink: json['menu_link'],
        menuImage: json['menu_image']);
  }
}
