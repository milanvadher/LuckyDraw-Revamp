import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/quizlevel.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/ui/animated_dialog_box.dart';
import 'package:youth_app/src/ui/ay_profile.dart';
import 'package:youth_app/src/ui/leaderboard.dart';

import '../../utils/cachedata.dart';
import '../game.dart';

class GnaniPurushLevel extends StatefulWidget {
  int categoryNumber;

  GnaniPurushLevel(this.categoryNumber);

  @override
  _GnaniPurushLevelState createState() => _GnaniPurushLevelState();
}

class _GnaniPurushLevelState extends State<GnaniPurushLevel> {
  List<QuizLevel> levelList;
  PublishSubject<bool> refreshUi = PublishSubject<bool>();

  Widget levelCard(
    int index,
    bool isCompleted,
    bool isTimeBased,
    QuizLevel level,
  ) {
    bool isThreelevel =
        level.description != null && level.description.isNotEmpty;
    return Container(
      margin: EdgeInsets.all(8),
      decoration: new BoxDecoration(
        border: new Border.all(
            color: isCompleted ? Colors.greenAccent : Colors.orangeAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(isTimeBased ? Icons.timer : Icons.timeline),
          ),
          title: Container(
            margin: EdgeInsets.only(bottom: isThreelevel ? 2 : 5),
            child: Text('${level.name}', style: TextStyle(fontSize: 24)),
          ),
          subtitle: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: isThreelevel ? 5 : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
//                      Text('Level : ${level.levelIndex}'),  //  To remove because the level numbers will be wrong after adding gyani purush quiz
                      Text('Max. Points : ${level.totalscores}'),
                    ],
                  ),
                ),
                isThreelevel
                    ? Text(
                        '', // Changed because description is shown in the alert box
//                  '⭐ ${level.description}',
                  style: TextStyle(fontSize: 11),
                      )
                    : SizedBox(height: 0, width: 0),
              ],
            ),
          ),
          isThreeLine: isThreelevel,
          onTap: isCompleted
              ? () {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                      msg: 'Horray !! You have completed this Level',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.greenAccent,
                      textColor: Colors.black);
                }
              : () async {
                  await animated_dialog_box.showInOutDailog(
                    context: context,
                    yourWidget: Text(level.description),
                    firstButton: RaisedButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    secondButton: RaisedButton(
                      child: Text("Okay"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Game(
                              isBonusLevel: false,
                              level: level,
                            ),
                          ),
                        );
                        refreshUi.sink.add(true);
                      },
                    ),
                  );

                },
          trailing: isCompleted
              ? CircleAvatar(
                  backgroundColor: Colors.green.shade200,
                  child: Icon(Icons.done),
                )
              : Container(height: 0, width: 0),
        ),
      ),
    );
  }

  gridViewLevel(int index, bool isCompleted, bool isTimeBased,
      [QuizLevel level]) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        border: new Border.all(
            color: isCompleted ? Colors.greenAccent : Colors.orange),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child:
                    Icon(isTimeBased ? Icons.alarm : Icons.timeline, size: 30),
              ),
              Text(
                'Level $index',
                style: Theme.of(context).textTheme.headline,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    List<QuizLevel> tempLevelList =
        CacheData.userState != null ? CacheData.userState.quizLevels : [];
    levelList = tempLevelList.where((level) {
      return level.category[0].categoryNumber == 2;
    }).toList();

    refreshUi.sink.add(true);
  }

  bool isCompleted(int levelIndex) {
    List<CompletedLevel> completedLevels = CacheData.userState.completed;
    for (CompletedLevel completedLevel in completedLevels) {
      if (completedLevel.level == levelIndex) return true;
    }
    return false;
  }

  @override
  void dispose() {
    refreshUi.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Levels'),
        actions: <Widget>[
          IconButton(
            icon: Hero(
              tag: 'profile',
              child: Icon(Icons.account_circle),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AYProfile(2), // Category 2 for gnani purush category
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: refreshUi,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return ListView(
              padding: EdgeInsets.all(5),
              children: levelList.length > 0
                  ? levelList.map((level) {
                      return levelCard(
                        level.levelIndex,
                        isCompleted(level.levelIndex),
                        level.levelType == 'TIME_BASED',
                        level,
                      );
                    }).toList()
                  : [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 125,
                        ),
                        child: Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 25),
                                  child: Image(
                                    height: 100,
                                    image: AssetImage('images/chilling.png'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'No Levels Available',
                                    style: TextStyle(fontSize: 24, height: 1.3),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Leaderboard(widget.categoryNumber)),
          );
          // Fluttertoast.showToast(msg: 'Leaderboard !! Work in progress !!!');
        },
        child: Image(
          image: AssetImage('images/leaderboard.png'),
          height: 50,
        ),
      ),
    );
  }
}
