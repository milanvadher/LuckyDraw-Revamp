import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class AnsResultAnimation {
  static rightAns(BuildContext context, bool hintTaken) async {
    await mainView(
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
      isHintTaken: hintTaken,
    );
  }

  static wrongAns(BuildContext context) async {
    await mainView(
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

  static rightAnsWithCoupon(BuildContext context, String msg, bool hintTaken) async {
    await mainView(
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
      isGetCoupon: true,
      msg: msg,
      isHintTaken: hintTaken,
    );
  }
}

mainView({
  @required BuildContext context,
  @required Widget signAnimation,
  @required bool isCorrectAns,
  bool isGetCoupon = false,
  String msg,
  bool isHintTaken = false,
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
                  height: screenHeight - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      signAnimation,
                      AnsResult(
                        isCorrectAns: isCorrectAns,
                        isGetCoupon: isGetCoupon,
                        msg: msg,
                        isHintTaken: isHintTaken,
                      ),
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
  final bool isGetCoupon;
  final String msg;
  final bool isHintTaken;

  AnsResult({
    @required this.isCorrectAns,
    @required this.isGetCoupon,
    this.msg,
    this.isHintTaken = false,
  });
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
                  widget.isCorrectAns ? widget.isHintTaken ? '+0' : '+100' : '',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              widget.isHintTaken
                  ? Container(
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Text(
                        'You can\'t get point. Bcz you use Hint.',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
              widget.isGetCoupon
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        '${widget.msg}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    )
            ],
          ),
        );
      },
    );
  }
}
