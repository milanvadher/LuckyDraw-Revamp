import 'package:flutter/material.dart';
import 'package:youth_app/webViewPage.dart';
import 'package:animated_background/animated_background.dart';

import 'api/fetchUser.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final Future<List<dynamic>> listUsers = fetchUsers();
  ParticleOptions particularsOptions = const ParticleOptions(
    maxOpacity: 0.3,
    particleCount: 50,
    spawnMinSpeed: 10.0,
    spawnMaxSpeed: 100.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(options: particularsOptions),
        vsync: this,
        child: FutureBuilder<List<dynamic>>(
          future: listUsers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Text(
                            'Youth App',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 500
                                        ? 60
                                        : 40,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: GridView.builder(
                        padding: EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8.0,
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 500 ? 4 : 2,
                            crossAxisSpacing: 8.0),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Container(
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        snapshot.data
                                            ?.elementAt(index)
                                            .menuTitle!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    700
                                                ? 25
                                                : 21,
                                            color: Colors.blue.shade700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              if (snapshot.data
                                      ?.elementAt(index)
                                      ?.menuLink
                                      ?.length >
                                  0)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewPage(
                                            url: snapshot.data
                                                ?.elementAt(index)
                                                .menuLink,
                                            title: snapshot.data
                                                ?.elementAt(index)
                                                .menuTitle,
                                          )),
                                );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Youth App',
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width > 500 ? 70 : 50,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    Text(
                      'Check your internet connection ...',
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width > 500 ? 25 : 15,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
              ),
            );
          },
        ),
      ),
    );
  }
}
