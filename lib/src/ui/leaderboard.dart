import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/leaders.dart';
import 'package:youth_app/src/utils/common_function.dart';
import '../bloc/bloc.dart';
import '../utils/cachedata.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  PublishSubject<int> userRank = PublishSubject<int>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userRank.drain();
    super.dispose();
  }

  setUserPosition(LeaderList leaderList) {
    userRank.sink.add(leaderList.userRank + 1);
  }

  @override
  Widget build(BuildContext context) {
    Widget leaderList() {
      return Container(
        child: StreamBuilder(
          stream: bloc.leadersList,
          builder: (BuildContext context, AsyncSnapshot<LeaderList> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.leaders.length == 0) {
                return ListView(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 160,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Theme.of(context).accentColor,
                              size: 80,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 20),
                              child: Text(
                                'No Leaders Available of this Month',
                                style: Theme.of(context).textTheme.headline,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              // widget.setUserPosition(snapshot.data);
              // return ListView.separated(
              //   separatorBuilder: (BuildContext context, int index) => Divider(
              //     height: 0,
              //     indent: 80,
              //     color: Colors.grey.shade600,
              //   ),
              //   itemCount: snapshot.data.leaders.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return Leader(
              //       name: '${snapshot.data.leaders[index].name}',
              //       points: '${snapshot.data.leaders[index].totalscoreMonth}',
              //       rank: '${index + 1}',
              //       profilePic:
              //           '${snapshot.data.leaders[index].profilePic ?? ""}',
              //       mhtId: snapshot.data.leaders[index].mhtId,
              //       profilePicVersion:
              //           snapshot.data.leaders[index].profilePicVersion,
              //     );
              //   },
              // );
            }
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(
                    '${snapshot.error}',
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(135),
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 27,
                        backgroundColor: Theme.of(context).accentColor,
                        child: Icon(Icons.portrait),
                      ),
                      title: Text(
                        '${CacheData.userInfo?.username}',
                        style: Theme.of(context).textTheme.headline,
                      ),
                      subtitle: Text(
                        'Points : ${CacheData.userState?.totalscore}',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      selected: true,
                      trailing: Container(
                        child: StreamBuilder(
                          initialData: 0,
                          stream: userRank,
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '${snapshot.data}',
                                  style: Theme.of(context).textTheme.headline,
                                ),
                                Text(
                                    '${CommonFunction.getOrdinalOfNumber(snapshot.data)}')
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: leaderList(),
      ),
    );
  }
}
