import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:youth_app/src/course/models/session_detail.dart';
import 'package:youth_app/src/course/pages/session_detail/session_detail.dart';
import 'package:youth_app/src/course/services/course_cache.dart';
import 'package:youth_app/src/course/services/course_service.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final SessionDetail sessionDetail;

  const QuizPage({Key key, this.questions, this.sessionDetail})
      : super(key: key);

//  QuizPage(this.questions, this.sessionDetail);

  @override
  State<StatefulWidget> createState() {
    return QuizPageState();
  }
}

class QuizPageState extends State<QuizPage> {
  Question question;
  int index = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  CourseCache _courseCache = CourseCache();
  CourseService _courseService = CourseService();

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      backgroundColor: Color(0xff272727),
      isCloseButton: false,
      isOverlayTapDismiss: false,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      titleStyle: TextStyle(
        color: Colors.white,
      ),
      descStyle: TextStyle(color: Colors.white));

  @override
  void initState() {
    super.initState();
    updateQuestion();
    print("last ques tion attemoted");
    print(widget.sessionDetail.session.fields.last_question_attempted);
    navigateToLastAttemptedQuestion();
  }

  updateQuestion() {
    question = widget.questions[index];
  }

  navigateToLastAttemptedQuestion() {
    int last_quest_id =
        widget.sessionDetail.session.fields.last_question_attempted;
    if (last_quest_id != null) {
      int lastQuesIndex;
      for (int i = 0; i < widget.questions.length; i++) {
        if (last_quest_id == widget.questions[i].id) {
          lastQuesIndex = i + 1;
          break;
        }
      }

      index = lastQuesIndex;
      //     duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      //     duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      print("LAST QUES index $lastQuesIndex");
     if(lastQuesIndex >= widget.questions.length){ // If the quiz is over but session not complete, restart the quiz.
       lastQuesIndex = 0;
       index = 0;
     } 
      pageController =
          PageController(initialPage: lastQuesIndex, keepPage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xff121212),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xffffffff)),
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              _navigateToSession();
            },
          ),
          // title: Text("Quiz", style: TextStyle(color: Color(0xffffffff)),),
          // backgroundColor: Color(0xff272727),
          backgroundColor: Color(0xff121212),
        ),
        body: PageView.builder(
          itemCount: widget.questions.length,
          itemBuilder: (BuildContext context, int index) {
            return _quizBody(index);
          },
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
        ),
      ),
    );
  }

  Widget _quizBody(int index) {
    print(index);
    return Column(
      children: <Widget>[
        _quesNumberIndicator(index + 1, widget.questions.length),
        _question(index),
        Expanded(
          child: Container(),
        ),
        Column(children: _choices(context, index))
      ],
    );
  }

  Widget _quesNumberIndicator(int current, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            " Question  " + current.toString() + " of " + total.toString(),
            style: TextStyle(fontSize: 20, color: Colors.white70),
          )
        ],
      ),
    );
  }

  Widget _question(int index) {
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(minHeight: 150, minWidth: double.infinity),
      child: Card(
        color: Color(0xff272727),
        child: Container(
          alignment: Alignment(0, 0),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.questions[index].questionText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
    );
  }

  _sizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  _choices(BuildContext context, int index) {
    List<Choice> choices = widget.questions[index].choices;
    List<Widget> choiceButtons = [];
    choices.forEach((choice) => {
          choiceButtons.add(InkWell(
            onTap: () {
              optionPressed(choice, index, context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                minHeight: 80,
                minWidth: double.infinity,
              ),
              child: Card(
                color: Colors.deepOrange.shade300,
                child: Container(
                  alignment: Alignment(0, 0),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    choice.choiceText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                ),
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ))
        });
    return choiceButtons;
  }

  nextQues() {
    double page = pageController.page;
    index = page.toInt();
    _courseService.questionAttempted(
        widget.sessionDetail.session.pk, widget.questions[index].id);
    print("PAGE----");
    print(page);
    if (page + 1 >= widget.questions.length) {
      _courseCache.setQuizOver(widget.sessionDetail.session.pk);
      // print("Last PAge");
      Alert(
          context: context,
          style: alertStyle,
          type: AlertType.info,
          title: "Quiz Over",
          buttons: [
            DialogButton(
              color: Color(0xffBB86FC),
              child: Text(
                "okay",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                _navigateToSession();
              },
              width: 120,
            )
          ]).show();
      return;
    }
    pageController.nextPage(
        duration: Duration(seconds: 1), curve: Curves.bounceOut);
  }

  optionPressed(Choice choice, int index, BuildContext context) {
    var alertType;
    var title;
    var description;

    statsQuesUpdate(choice, index);
    Choice correctChoice = widget.questions[index].choices
        .where((choice) => choice.isAnswer)
        .toList()[0];

    if (choice.isAnswer) {
      alertType = AlertType.success;
      title = "Correct Answer";
      description = "";
    } else {
      alertType = AlertType.error;
      title = "Wrong Answer";
      description = "The correct answer is \n" + correctChoice.choiceText;
    }

    Alert(
      context: context,
      style: alertStyle,
      type: alertType,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          color: Color(0xffBB86FC),
          child: Text(
            "okay",
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            nextQues();
          },
          width: 120,
        )
      ],
    ).show();

    // print("Question Id" + question.id.toString());
    // print(choice.isAnswer);
    // print("Index" + index.toString());
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToSession();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  _navigateToSession() {
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => SessionDetailPage(
              widget.sessionDetail.course.pk, widget.sessionDetail.session.pk),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([]);
  }

  void statsQuesUpdate(Choice choice, int index) {
    Map<String, dynamic> quesData = {};
    quesData["question_id"] = widget.questions[index].id;
    quesData["attempted"] = true;
    quesData["answered_correctly"] = choice.isAnswer;
    quesData["choice"] = {"choice_id": choice.id, "chosen_count": 1};
    Map<String, dynamic> data = {};
    data["session_id"] = widget.sessionDetail.session.pk;
    data["questions"] = [quesData];

    _courseService.statisticQuestionUpdate(data);
  }
}
