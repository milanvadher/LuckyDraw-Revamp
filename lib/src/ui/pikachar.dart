import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/bloc/bloc.dart';
import 'package:lucky_draw_revamp/src/model/question.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/points.dart';

class Pikachar extends StatefulWidget {
  @override
  _PikacharState createState() => _PikacharState();
}

class _PikacharState extends State<Pikachar> {
  Future<bool> exitGame() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the Game ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showPhoto(BuildContext context, String tag, Image image) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        body: SizedBox.expand(
          child: Hero(
            tag: '$tag',
            child: image,
          ),
        ),
      );
    }));
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitGame,
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
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.spaceBetween,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(snapshot.data.imageList.length,
                          (int index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.width / 2.2,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(8.0),
                            child: Image.network(
                              '${getImageLink(imageSrc: snapshot.data.imageList[index])}',
                              width: MediaQuery.of(context).size.width / 2.2,
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
                        );
                      }).toList(),
                    )
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
