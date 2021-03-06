import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/ay_question.dart';
import 'package:youth_app/src/model/quizlevel.dart';
import 'package:youth_app/src/model/user_level.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/model/validate_answer.dart';
import 'package:youth_app/src/utils/points.dart';
import '../repository/auth_api_provider.dart';
import '../repository/question_api_provider.dart';
import '../utils/ans_result.dart';
import '../utils/cachedata.dart';
import '../utils/loading.dart';
import 'mcq.dart';

PublishSubject<bool> timeUp = PublishSubject<bool>();

class Game extends StatefulWidget {
  final QuizLevel level;
  final bool isBonusLevel;

  const Game({
    Key key,
    @required this.isBonusLevel,
    this.level,
  }) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  PublishSubject<AYQuestion> question = PublishSubject<AYQuestion>();
  QuestionApiProvider questionApiProvider = QuestionApiProvider();
  List<AYQuestion> questions;
  int curruntQuestionIndex = 0;
  UserLevel userLevel;

  @override
  void dispose() {
    question.drain();
    timeUp.drain();
    super.dispose();
  }

  @override
  void initState() {
    print('${widget.isBonusLevel}, ${widget.level}');
    if (CacheData.userState.currentLevels
        .where((lvl) => lvl.level == widget.level.levelIndex)
        .isEmpty) {
      checkLevelIsInCurruntLevel();
    }
    loadQuestions();
    super.initState();
  }
  // CacheData.userState.currentLevels

  checkLevelIsInCurruntLevel() async {
    try {
      Loading.show(context);
      UserLevel ul = await questionApiProvider.checkUserLevel(
        levelIndex: widget.level.levelIndex,
      );
      CacheData.userState.currentLevels.add(new Current(level: ul.level, questionSt: ul.questionSt));
      Loading.hide(context);
    } catch (e) {
      print('Error in checkLevelIsInCurruntLevel');
      print(e);
      Fluttertoast.showToast(
        msg: '$e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  listenTimesUp() {
    timeUp.stream.listen(timesUp);
  }

  timesUp(bool isTimesUp) {
    print('Time is UP ::: $isTimesUp');
    if (isTimesUp) {
      Navigator.push(
        context,
        PageRouteBuilder(
          barrierDismissible: false,
          transitionDuration: Duration(milliseconds: 100),
          barrierColor: Colors.black87,
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return ListView(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        size: 80,
                        color: Theme.of(context).accentColor,
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'Time\'s UP',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          OutlineButton(
                            onPressed: () {
                              print('Exit Level');
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.exit_to_app,
                                  size: 16,
                                  // color: Colors.black,
                                ),
                                Text(
                                  '  Exit',
                                  // style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              print('Next Que.');
                              Navigator.pop(context);
                              loadNextQuestion();
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.skip_next,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                Text(
                                  '  Next Que.',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      );
    }
  }

  loadQuestions() async {
    try {
      int fromQuestion = CacheData.userState.currentLevels
                  .where((level) => level.level == widget.level.levelIndex)
                  .toList()
                  .length >
              0
          ? CacheData.userState.currentLevels
              .where((level) => level.level == widget.level.levelIndex)
              .toList()[0]
              .questionSt
          : 0;
      questions = await questionApiProvider.getAllQuestions(
        level: widget.level,
        from: fromQuestion,
      );
    } catch (e) {
      question.sink.addError(e);
    }
    print('Questions ::: $questions');
    // print('Questions ::: ${CacheData.userState.currentLevels[widget.level.levelIndex].questionSt}');
    if (questions != null && questions.length > 0) {
      AYQuestion que = questions.getRange(0, 1).first;
      question.sink.add(que);
      curruntQuestionIndex = 0;
    } else {
      question.sink.addError('There are no questions !!');
    }
  }

  loadNextQuestion() async {
    print('============>> load Next <<============');
    if (curruntQuestionIndex < questions.length - 1) {
      curruntQuestionIndex++;
      AYQuestion que = questions
          .getRange(curruntQuestionIndex, curruntQuestionIndex + 1)
          .first;
      question.sink.add(que);
      print('Question $que');
    } else {
      question.sink.addError('${widget.level.name} is completed !!');
      loadUserState();
    }
  }

  loadUserState() async {
    try {
      Loading.show(context);
      final authApiProvider = AuthApiProvider();
      UserState userState = await authApiProvider.loadUserState(
        mobileNo: '${CacheData.userInfo?.contactNumber}',
        category: 1,
      );
      CacheData.userState = userState;
      Loading.hide(context);
    } catch (e) {
      Loading.hide(context);
      Fluttertoast.showToast(
        msg: '$e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<bool> validateAnswer({
    int level,
    String answer,
    int questionId,
  }) async {
    print('Validate Ans');
    try {
      Loading.show(context);
      QuestionApiProvider questionApiProvider = new QuestionApiProvider();
      ValidateAnswer validateAnswer = await questionApiProvider.validateAnswer(
          answer: answer,
          level: level,
          questionId: questionId,
          categoryNumber: widget.level.category[0].categoryNumber);
      (CacheData.userState.currentLevels
              .where((lvl) => lvl.level == widget.level.levelIndex))
          .first
          .questionSt = validateAnswer.questionSt;
      print('Validate ANS ===> ');
      CacheData.userState.totalscoreMonth = validateAnswer.totalscoreMonth;
      CacheData.userState.totalscoreWeek = validateAnswer.totalscoreWeek;
      CacheData.userInfo.questionState = validateAnswer.questionSt;
      Point.updatePoint(
          categoryNumber: widget.level.category[0].categoryNumber);
      print(validateAnswer.answerStatus);
      Loading.hide(context);
      if (validateAnswer.answerStatus) {
        validateAnswer.updateSessionScore(
            categoryNumber: widget.level.category[0].categoryNumber);
        await AnsResultAnimation.rightAns(context, false);
      } else {
        await AnsResultAnimation.wrongAns(context);
      }
      await loadNextQuestion();
      return validateAnswer.answerStatus;
    } catch (e) {
      Loading.hide(context);
      Fluttertoast.showToast(
        msg: '$e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget questionNumber() {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.isBonusLevel ? 'DailyBonus' : 'Question',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 12,
              ),
            ),
            StreamBuilder(
              stream: question,
              builder:
                  (BuildContext context, AsyncSnapshot<AYQuestion> snapshot) {
                return Text(
                  '${snapshot.hasData ? snapshot.data.questionSt : 1}/${!widget.isBonusLevel ? widget.level.totalQuestions : 0}',
                  style: TextStyle(fontSize: 20),
                );
              },
            )
          ],
        ),
      );
    }

    Widget questionWidget(String que) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 160,
          ),
          child: Center(
            child: Text(
              '$que',
              style: TextStyle(
                fontFamily: 'Gujarati',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: questionNumber(),
        centerTitle: true,
        actions: <Widget>[
          Point.display(widget.level.category[0].categoryNumber),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: question,
          builder: (BuildContext context, AsyncSnapshot<AYQuestion> snapshot) {
            if (snapshot.hasData) {
              return MCQ(
                question: questionWidget(snapshot.data.question),
                options: snapshot.data.options,
                answerIndex: snapshot.data.answerIndex,
                level: widget.level,
                questionId: snapshot.data.questionId,
                validateAnswer: validateAnswer,
              );
            }
            if (snapshot.hasError) {
              return ListView(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 100),
                    child: Container(
                      padding: EdgeInsets.all(35),
                      child: Center(
                        child: Text(
                          '${snapshot.error}',
                          style: Theme.of(context).textTheme.headline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
