import 'dart:convert';
import 'dart:developer';
import 'dart:html';

// Import for Android features.
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: CardItemGrid(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CardItemGrid extends StatelessWidget {
  Future<List<dynamic>> listUsers = fetchUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<dynamic>>(
      future: listUsers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: ArcClipper(80.0),
                  child: Container(
                    color: Colors.blueGrey.shade600,
                    height: 200.0,
                    padding: EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: Text(
                        'Youth App',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 500
                                ? 45
                                : 25,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 8.0,
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 500 ? 4 : 2,
                        crossAxisSpacing: 8.0),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  snapshot.data?.elementAt(index).menuTitle!,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  700
                                              ? 25
                                              : 18,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewApp()),
                          );
                          print(snapshot.data?.elementAt(index).menuLink);
                          // fetchUsers();
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.cyanAccent,
          ),
        );
      },
    ));
  }
}

class ArcClipper extends CustomClipper<Path> {
  ArcClipper(this.height);

  final double height;

  @override
  Path getClip(Size size) => _getBottomPath(size);

  Path _getBottomPath(Size size) {
    return Path()
      ..lineTo(0.0, size.height - height)
      //Adds a quadratic bezier segment that curves from the current point
      //to the given point (x2,y2), using the control point (x1,y1).
      ..quadraticBezierTo(
          size.width / 4, size.height, size.width / 2, size.height)
      ..quadraticBezierTo(
          size.width * 3 / 4, size.height, size.width, size.height - height)
      ..lineTo(size.width, 0.0)
      ..close();
  }

  @override
  bool shouldReclip(ArcClipper oldClipper) => height != oldClipper.height;
}

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

class WebViewApp extends StatefulWidget {
  const WebViewApp();

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

// class _WebViewAppState extends State<WebViewApp> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     // throw UnimplementedError();

//     return InAppWebView(
//       initialUrlRequest:
//           URLRequest(url: Uri.parse("https://inappwebview.dev/")),
//     );
//   }
// }

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    // webviewPlat?.createPlatformWebViewController(params);

    // TODO: implement build
    return Container(
      child: WebViewWidget(controller: controller),
    );
  }
}
