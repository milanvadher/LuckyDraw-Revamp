import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class AnsResultAnimation {
  static rightAns(BuildContext context) async {
    mainView(
      context: context,
      signAnimation: Container(
        width: 200,
        height: 200,
        child: FlareActor(
          'images/animation/right-ans.flr',
          animation: 'done',
          fit: BoxFit.fitHeight,
        ),
      ),
      isCorrectAns: true,
    );
  }

  static wrongAns(BuildContext context) async {
    mainView(
      context: context,
      signAnimation: Container(
        margin: EdgeInsets.only(bottom: 30),
        width: 100,
        height: 100,
        child: FlareActor(
          'images/animation/wrong-ans.flr',
          animation: 'wrong',
          fit: BoxFit.fitHeight,
        ),
      ),
      isCorrectAns: false,
    );
  }
}

mainView({
  @required BuildContext context,
  @required Widget signAnimation,
  @required bool isCorrectAns,
}) async {
  double screenHeight = MediaQuery.of(context).size.height;
  Navigator.of(context).push(
    PageRouteBuilder(
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 250),
      barrierColor: Colors.black87,
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: <Widget>[
                Container(
                  height: screenHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      signAnimation,
                      AnsResult(isCorrectAns: isCorrectAns),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}

class AnsResult extends StatefulWidget {
  final bool isCorrectAns;

  AnsResult({@required this.isCorrectAns});
  @override
  _AnsResultState createState() => _AnsResultState();
}

class _AnsResultState extends State<AnsResult> {
  final PublishSubject<bool> isVisible = PublishSubject<bool>();

  @override
  void initState() {
    startAnimation();
    stopAnimation();
    super.initState();
  }

  startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    isVisible.sink.add(true);
  }

  stopAnimation() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    isVisible.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: isVisible,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.data ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'Your answer is',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  widget.isCorrectAns ? 'Correct' : 'In-Correct',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  widget.isCorrectAns ? '+100' : '',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
