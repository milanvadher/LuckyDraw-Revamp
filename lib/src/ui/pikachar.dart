import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/bloc/bloc.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/common_function.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:lucky_draw_revamp/src/utils/points.dart';
import 'package:rxdart/rxdart.dart';

class Pikachar extends StatefulWidget {
  @override
  _PikacharState createState() => _PikacharState();
}

class _PikacharState extends State<Pikachar> {
  final Repository repository = Repository();
  final PublishSubject<bool> refreshUI = PublishSubject<bool>();
  List<String> userAnswer;
  List<bool> disabledOption;
  int answerLength;
  List<String> options;
  String answer;

  void showPhoto(BuildContext context, String tag, String imageSrc) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            body: SizedBox.expand(
              child: Hero(
                tag: '$tag',
                child: Image.network(imageSrc),
              ),
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  String getImageLink({@required String imageSrc}) {
    return imageSrc.replaceFirst(new RegExp(r'localhost'), '3.16.51.94');
  }

  setupData(Question question) {
    answer = question.answer.split(' ')[0];
    answerLength = answer.length;
    options = question.randomString.split('');
    userAnswer = List.generate(answerLength, (int index) => '');
    disabledOption = List.generate(options.length, (int index) => false);
  }

  checkAns() async {
    bool result = userAnswer.join().toLowerCase() == answer.toLowerCase();
    if (result) {
      print('Answer is correct ${userAnswer.join('')}');
      Loading.show(context);
      User user = await repository.saveUserData(
        points: CacheData.userInfo.points + 100,
        questionState: CacheData.userInfo.questionState + 1,
      );
      CacheData.userInfo = user;
      await Point.updatePoint();
      await bloc.getQuestion(questionState: CacheData.userInfo.questionState);
      Loading.hide(context);
    } else {
      print('Answer is In-Correct ${userAnswer.join('')}');
    }
  }

  onOptionClick(String char, int index) {
    if (userAnswer.contains('')) {
      disabledOption[index] = true;
      userAnswer[userAnswer.indexWhere((node) => node.isEmpty)] = char;
      refreshUI.sink.add(true);
    }
    if (!userAnswer.contains('')) {
      checkAns();
    }
  }

  onAnswerClick(String char, int index) {
    if (userAnswer[index].isNotEmpty) {
      for (var i = 0; i < options.length; i++) {
        if (disabledOption[i] && options[i] == char) {
          disabledOption[i] = false;
          break;
        }
      }
      userAnswer[index] = '';
      refreshUI.sink.add(true);
    }
  }

  @override
  void initState() {
    bloc.getQuestion(questionState: CacheData.userInfo?.questionState);
    Point.updatePoint();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    refreshUI.close();
    super.dispose();
  }

  Widget pikView({@required Question question}) {
    double size = MediaQuery.of(context).size.width / 2.5;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceBetween,
      spacing: 5,
      runSpacing: 5,
      children: List.generate(question.imageList.length, (int index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(4.0),
            child: InkWell(
              onTap: () {
                showPhoto(context, 'image_$index',
                    getImageLink(imageSrc: question.imageList[index]));
              },
              child: Hero(
                tag: 'image_$index',
                child: Image.network(
                  '${getImageLink(imageSrc: question.imageList[index])}',
                  width: size,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent imageChunkEvent,
                  ) {
                    if (imageChunkEvent?.cumulativeBytesLoaded ==
                        imageChunkEvent?.expectedTotalBytes) {
                      return child;
                    }
                    return Center(
                      child: CommonWidget.progressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildAnswerTile(String char, int index) {
    bool isDisable = char.isEmpty;
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: MaterialButton(
        elevation: isDisable ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        onPressed: isDisable
            ? null
            : () {
                onAnswerClick(char, index);
              },
        child: Text(
          '${char.toUpperCase()}',
          style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 24,
                color: Colors.black,
              ),
        ),
        color: Theme.of(context).primaryColor,
        disabledColor: Theme.of(context).primaryColor.withAlpha(120),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget answerTiles() {
    return StreamBuilder(
      stream: refreshUI,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 6.0,
            spacing: 6.0,
            children: List.generate(
              answerLength,
              (int index) => buildAnswerTile(userAnswer[index], index),
            ),
          ),
        );
      },
    );
  }

  Widget buildOptionTile(String char, int index) {
    bool isDisable = disabledOption[index];
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        border: new Border.all(
          color: isDisable
              ? Theme.of(context).primaryColor.withAlpha(100)
              : Theme.of(context).primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        onPressed: isDisable
            ? null
            : () {
                onOptionClick(char, index);
              },
        child: Text(
          '${char.toUpperCase()}',
          style: isDisable
              ? Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 24,
                    color: Colors.grey,
                  )
              : Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 24,
                  ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget optionsTiles() {
    return StreamBuilder(
      stream: refreshUI,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 6.0,
            spacing: 6.0,
            children: List.generate(
              options.length,
              (int index) => buildOptionTile(options[index], index),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return CommonFunction.onWillPop(
            context: context, msg: 'Do you want to exit the Game ?');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pikachar'),
          actions: <Widget>[
            Point.display(),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: bloc.question,
            builder: (BuildContext context, AsyncSnapshot<Question> snapshot) {
              if (snapshot.hasData) {
                setupData(snapshot.data);
                return ListView(
                  padding: EdgeInsets.all(10),
                  children: <Widget>[
                    pikView(question: snapshot.data),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: answerTiles(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: optionsTiles(),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                return CommonWidget.displayError(
                  context: context,
                  error: snapshot.error,
                );
              }
              return CommonWidget.progressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
