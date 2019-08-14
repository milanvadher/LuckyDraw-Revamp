import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final Widget homepage;

  MyApp({@required this.homepage});

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.blueAccent.shade100,
    iconTheme: IconThemeData(
      color: Colors.blueAccent.shade100,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blueAccent.shade100,
      textTheme: ButtonTextTheme.primary,
    ),
    errorColor: Colors.red,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.black12,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Draw JJ112',
      theme: darkTheme,
      darkTheme: darkTheme,
      home: homepage,
    );
  }
}
