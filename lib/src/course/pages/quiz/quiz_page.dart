import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:youth_app/src/course/models/session_detail.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final SessionDetail sessionDetail;

  QuizPage(this.questions, this.sessionDetail);

  @override
  State<StatefulWidget> createState() {
    return QuizPageState();
  }
}

class QuizPageState extends State<QuizPage> {
  Question question;
  int index = 0;

  @override
  void initState() {
    super.initState();
    updateQuestion();
  }

  updateQuestion() {
    question = widget.questions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quiz"),
        ),
        body: _quizBody());
  }

  _quizBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 0.0,
            margin:
                EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 20.0),
            color: Color(0x00000000),
            child: FlipCard(
              direction: FlipDirection.VERTICAL,
              speed: 500,
              onFlipDone: (status) {
                print(status);
              },
              front: _front(),
              back: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF006666),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Back', style: Theme.of(context).textTheme.headline),
                    Text('Click here to flip front',
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _front(){
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF006666),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        children: <Widget>[
          _question(),
          Text('Click here to flip back',
              style: Theme.of(context).textTheme.body1),
        ],
      ),
    );
  }

  _question(){
    return Text(question.questionText);
  }
}
