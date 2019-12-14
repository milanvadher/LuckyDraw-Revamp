import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/ay_question.dart';
import 'package:youth_app/src/model/quizlevel.dart';

class MCQ extends StatefulWidget {
  final Widget question;
  final List<Options> options;
  final int answerIndex;
  final int questionId;
  final QuizLevel level;
  final Function validateAnswer;
  MCQ({
    @required this.question,
    @required this.options,
    @required this.answerIndex,
    @required this.questionId,
    @required this.level,
    @required this.validateAnswer,
  });

  @override
  _MCQState createState() => _MCQState();
}

class _MCQState extends State<MCQ> with TickerProviderStateMixin {
  final PublishSubject<bool> isTapOption = PublishSubject<bool>();
  int rightAnsIndex;
  int selectedIndex;
  AnimationController _controller;
  Animation _animationOp1, _animationOp2, _animationOp3, _animationOp4;

  _MCQState() {
    print('_MCQState Constructor');
  }

  initData() {
    print('*************** Init MCQ ***************');
    rightAnsIndex = widget.answerIndex;
    isTapOption.sink.add(false);
    selectedIndex = 0;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    easyIn();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _controller.dispose();
    isTapOption.drain();
    super.dispose();
  }

  easyIn() {
    _controller.reset();

    _animationOp1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _animationOp2 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.05, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animationOp3 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animationOp4 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.15, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _controller.forward();
  }

  easyOut() {
    _controller.reset();

    _animationOp1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _animationOp2 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.05, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animationOp3 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animationOp4 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.15, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _controller.forward();
  }

  Animation getAnimation(int index) {
    switch (index) {
      case 2:
        return _animationOp2;
        break;
      case 3:
        return _animationOp3;
        break;
      case 4:
        return _animationOp4;
        break;
      default:
        return _animationOp1;
    }
  }

  Widget getIconOnOptionSelect(bool isTapOption, int index) {
    if (isTapOption && index == selectedIndex) {
      return Icon(Icons.check_circle_outline, color: Colors.black);
    }
    return Container(height: 5, width: 5);
  }

  onOptionClick(int index) async {
    selectedIndex = index;
    isTapOption.sink.add(true);
    bool result = await widget.validateAnswer(
      level: widget.level.levelIndex,
      answer: widget.options[selectedIndex].option,
      questionId: widget.questionId,
    );
    print('OnOptionClick ====>');
    print(result);
      await easyOut();
      await initData();
      isTapOption.sink.add(false);
    // if (result) {
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    Widget option(int index, Options option) {
      return Container(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return Transform(
              transform: Matrix4.translationValues(
                getAnimation(index).value * width,
                0.0,
                0.0,
              ),
              child: StreamBuilder(
                stream: isTapOption,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Card(
                    color: snapshot.data &&
                            index == selectedIndex &&
                            index == rightAnsIndex
                        ? Theme.of(context).accentColor
                        : snapshot.data && index == selectedIndex
                            ? Theme.of(context).accentColor
                            : Theme.of(context).cardColor,
                    child: ListTile(
                      onTap: () {
                        print(index);
                        onOptionClick(index);
                      },
                      leading: getIconOnOptionSelect(snapshot.data, index),
                      title: Text(
                        '${option.option}',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Gujarati',
                          color: snapshot.data && index == selectedIndex
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    Widget options = Container(
      child: Column(
        children: <Widget>[
          option(0, widget.options[0]),
          option(1, widget.options[1]),
          option(2, widget.options[2]),
          option(3, widget.options[3]),
        ],
      ),
    );

    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        widget.question,
        options,
      ],
    );
  }
}
