import 'package:flutter/material.dart';

import 'homePage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youth App',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
