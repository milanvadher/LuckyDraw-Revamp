import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/bloc/bloc.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/common_function.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/points.dart';

class Pikachar extends StatefulWidget {
  @override
  _PikacharState createState() => _PikacharState();
}

class _PikacharState extends State<Pikachar> {
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

  @override
  void initState() {
    bloc.getQuestion(questionState: CacheData.userInfo?.questionState);
    Point.updatePoint();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget pikView({@required Question question}) {
    double size = MediaQuery.of(context).size.width / 2.2;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceBetween,
      spacing: 6,
      runSpacing: 6,
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

  Widget charView({@required Question question}) {
    List<String> answer = question.answer.split('');
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 6.0,
      spacing: 6.0,
      children: answer.map((String char) {
        return Container(
          width: 40,
          height: 40,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            onPressed: char.isEmpty
                ? null
                : () {
                    print(char);
                  },
            child: Text(
              '${char.toUpperCase()}',
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 24,
                    color: Colors.black,
                  ),
            ),
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(0),
          ),
        );
      }).toList(),
    );
  }

  Widget questionCharView({@required Question question}) {
    List<String> jumbleData = question.randomString.split('');
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 6.0,
      spacing: 6.0,
      children: jumbleData.map((String char) {
        return Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            border: new Border.all(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            onPressed: char.isEmpty
                ? null
                : () {
                    print(char);
                  },
            child: Text(
              '${char.toUpperCase()}',
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 24,
                  ),
            ),
            padding: EdgeInsets.all(0),
          ),
        );
      }).toList(),
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
                return ListView(
                  padding: EdgeInsets.all(10),
                  children: <Widget>[
                    pikView(question: snapshot.data),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: charView(question: snapshot.data),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: questionCharView(question: snapshot.data),
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
