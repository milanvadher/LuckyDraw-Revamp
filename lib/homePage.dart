import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:youth_app/webViewPage.dart';
import 'package:animated_background/animated_background.dart';

import 'api/fetchUserApi.dart';
import 'api/notifyMeApi.dart';

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

  String name = "";
  String number = "";
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _numberFieldController = TextEditingController();
  bool registeredNoti = false;

  callNotifyMeApi(String name, String number) {
    notifyMeApi(name, number).then((value) {
      registeredNoti = true;
      final snackBar = SnackBar(
        content: Text(value.toString() == (1).toString()
            ? "User Registation to Notification Successfull."
            : "User Already Registered for Notification!"),
        behavior: SnackBarBehavior.fixed,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return value;
    }).onError((error, stackTrace) {
      final snackBar = SnackBar(
        content: Text("Got error : " + error.toString()),
        behavior: SnackBarBehavior.fixed,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return error.toString();
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: ListTile(
              title: Text('Notify Me'),
              subtitle: Text(
                  "Fill in the form below to get regular notification on the arraival of new Akram Youth"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  controller: _nameFieldController,
                  decoration: InputDecoration(
                      hintText: "Enter your name", label: Text("Full Name")),
                ),
                TextField(
                  onChanged: (value) {
                    number = value;
                  },
                  keyboardType: TextInputType.number,
                  controller: _numberFieldController,
                  decoration: InputDecoration(
                      hintText: "Enter your Mobile Number",
                      label: Text("Mobile Number")),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) => 1.0),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.red.shade300),
                ),
                child: Text('CANCEL', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) => 1.0),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.green.shade300),
                ),
                child: Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  callNotifyMeApi(name, number);
                  _nameFieldController.clear();
                  _numberFieldController.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: registeredNoti
          ? null
          : FloatingActionButton.small(
              onPressed: () => _displayTextInputDialog(context),
              child: Icon(Icons.notifications),
              tooltip: "Get Akram Youth Notifications...",
            ),
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
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(snapshot.data
                                          ?.elementAt(index)
                                          ?.menuImage),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
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
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // menu_image
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
                    Text(
                      'Error |::| ' + snapshot.error.toString(),
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
