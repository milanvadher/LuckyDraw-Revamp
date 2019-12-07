import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:rxdart/rxdart.dart';

PublishSubject<bool> isDarkThemeStream = PublishSubject<bool>();

class MyApp extends StatefulWidget {
  final Widget homepage;

  const MyApp({Key key, this.homepage}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData appTheme;

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.cyan,
    accentColor: Colors.cyan[200],
    fontFamily: 'GoogleSans',
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.cyan,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  );

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.orangeAccent,
    accentColor: Colors.orangeAccent[100],
    fontFamily: 'GoogleSans',
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    ),
  );

  @override
  void initState() {
    isDarkThemeStream.sink.add(CacheData.isDarkTheme ?? false);
    super.initState();
  }

  @override
  void dispose() {
    isDarkThemeStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: CacheData.isDarkTheme,
      stream: isDarkThemeStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return MaterialApp(
          title: 'Today\'s Youth',
          theme: snapshot.data ? darkTheme : lightTheme,
          darkTheme: darkTheme,
          home: widget.homepage,
        );
      },
    );
  }
}
