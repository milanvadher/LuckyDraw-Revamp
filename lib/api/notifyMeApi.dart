import 'package:http/http.dart' as http;

Future<String> notifyMeApi(String name, String number) async {
  final response = await http.get(Uri.parse(
      "https://youth.dadabhagwan.org/umbraco/Surface/YouthSurface/AddAYSubscriber?FullName=" +
          name +
          "&WANumber=" +
          number));
  if (response.statusCode == 200) {
    return response.body;
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
