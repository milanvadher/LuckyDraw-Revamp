import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/leaders.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/setup.dart';
import '../bloc/bloc.dart';
import '../utils/cachedata.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  // ProfilePicService profilePicService = ProfilePicService();
  // PublishSubject<ImageProvider> userProfilePic =
  //     PublishSubject<ImageProvider>();
  PublishSubject<int> userRank = PublishSubject<int>();

  @override
  void initState() {
    bloc.getLeaderboard();
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
    Widget leader(data, index) {
      return ListTile(
        leading: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${index}',
                style: Theme.of(context).textTheme.headline,
              ),
              Text('${Setup.getOrdinalOfNumber(int.parse(index))}'),
            ],
          ),
        ),
        title: data.rank != '1'
            ? Text('${data.name}')
            : Text('${data.name}', style: Theme.of(context).textTheme.title),
        trailing: Container(
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Text(
              ' ${data.totalscoreMonth}',
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        ),
      );
    }

    Widget leaderList() {
      return Container(
        child: StreamBuilder(
          stream: bloc.leadersList,
          builder: (BuildContext context, AsyncSnapshot<LeaderList> snapshot) {
            if (snapshot.hasData) {
              // setUserPosition(snapshot.data);
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0,
                  indent: 80,
                  color: Colors.grey.shade600,
                ),
                itemCount: snapshot.data.leaders.length,
                itemBuilder: (BuildContext context, int index) {
                  return leader(snapshot.data.leaders[index], index);
                },
              );
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
                        backgroundImage: AssetImage('images/leaderboard.png'),
                        radius: 27,
                        backgroundColor: Theme.of(context).accentColor,
                        child: Text(
                          '15th',
                          // '${snapshot.data}',`     When we get the data from api
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      title: Text(
                        '${CacheData.userInfo?.username}',
                        style: Theme.of(context).textTheme.headline,
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
