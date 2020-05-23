import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youth_app/src/course/models/session_detail.dart';
import 'package:youth_app/src/course/pages/common_widgets/description.dart';
import 'package:youth_app/src/course/pages/common_widgets/divider.dart';
import 'package:youth_app/src/course/pages/common_widgets/document_links.dart';
import 'package:youth_app/src/course/pages/course_detail/course_detail.dart';
import 'package:youth_app/src/course/pages/quiz/quiz_page.dart';
import 'package:youth_app/src/course/services/course_cache.dart';
import 'package:youth_app/src/course/services/course_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SessionDetailPage extends StatefulWidget {
  final int parentCourseId;
  final int sessionId;

  SessionDetailPage(this.parentCourseId, this.sessionId);

  @override
  State<StatefulWidget> createState() {
    return SessionDetailState();
  }
}

class SessionDetailState extends State<SessionDetailPage> {
  CourseService _courseService = CourseService();
  CourseCache _courseCache = CourseCache();
  SessionDetail sessionDetail;
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _fetchSession(widget.parentCourseId, widget.sessionId);
    _sessionUpdate();
  }

  @override
  void deactivate() {
    super.deactivate();
    // Pauses video while navigating to next page.
    if (_controller != null) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD Session Detail");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Color(0xff121212),
      // **NULL CHECKS TO AVOID ACCESSING BEFORE LOADING**
      appBar: AppBar(
        backgroundColor: Color(0xff272727),
        iconTheme: IconThemeData(color: Color(0xffffffff)),
        elevation: 8,
        title: sessionDetail == null
            ? Text("")
            : Text(
                sessionDetail.session.fields.sessionName,
                style: TextStyle(color: Colors.white),
              ),
      ),
      body: sessionDetail == null
          ? Center(child: CircularProgressIndicator())
          : _sessionDetailView(sessionDetail),
      floatingActionButton: sessionDetail == null
          ? Container()
          : _playQuizButton(sessionDetail.session.questions),
    );
  }

  _sessionDetailView(SessionDetail sessionDetail) {
    return Column(
      children: <Widget>[
        _video(),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Description(sessionDetail.session.fields.sessionDescription),
            LineDivider(),
            DocumentLinks(sessionDetail.session.fields.documentLink, context)
          ],
        )
      ],
    );
  }

  _playQuizButton(List<Question> questions) {
    if (questions.length > 0) {
      //      _controller.pause();
      return FloatingActionButton.extended(
        backgroundColor: Colors.lightGreenAccent,
        onPressed: () {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => QuizPage(
                      questions: questions, sessionDetail: sessionDetail)));
        },
        label: Text("  Play Quiz"),
        icon: Icon(FontAwesomeIcons.gamepad),
      );
    } else {
      _courseCache.setQuizOver(widget.sessionId);
      return Container();
    }
  }

  _video() {
    // **NULL CHECKS TO AVOID ACCESSING BEFORE LOADING**
    if (sessionDetail.session.fields.sessionVideo == null) {
      _courseCache.setVideoOver(widget.sessionId);
      return Container();
    }

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          sessionDetail.session.fields.sessionVideo.videoUrl),
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onEnded: (metaData) {
        _courseCache.setVideoOver(widget.sessionId);
        // print(metaData);
        print("Ended");
        _sessionUpdate();
        _courseService.statisticVideoUpdate(widget.sessionId);
      },
    );
  }

  _fetchSession(int courseId, int sessionId) async {
    _courseService.getSessionById(courseId, sessionId).then((data) {
      setState(() {
        this.sessionDetail = data;
      });
    });
  }

  _sessionUpdate() async {
    bool isQuizOver = await _courseCache.getQuizStatus(widget.sessionId) ?? false;
    bool isVideoOver = await _courseCache.getVideoStatus(widget.sessionId) ?? false;
    print("SESSION STATUS");
    print(isQuizOver);
    print(isVideoOver);
    if (isQuizOver && isVideoOver) {
      _courseService.sessionComplete(widget.sessionId);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
    // SystemChrome.setPreferredOrientations([]);
  }
}
