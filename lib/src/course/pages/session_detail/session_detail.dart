import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youth_app/src/course/models/session_detail.dart';
import 'package:youth_app/src/course/pages/common_widgets/description.dart';
import 'package:youth_app/src/course/pages/common_widgets/divider.dart';
import 'package:youth_app/src/course/pages/common_widgets/document_links.dart';
import 'package:youth_app/src/course/pages/quiz/quiz_page.dart';
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
  SessionDetail sessionDetail;
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _fetchSession(widget.parentCourseId, widget.sessionId);
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D1019),
      // **NULL CHECKS TO AVOID ACCESSING BEFORE LOADING**
      appBar: AppBar(
        title: sessionDetail == null
            ? Text("")
            : Text(sessionDetail.session.fields.sessionName),
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
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => QuizPage(questions, sessionDetail)));
        },
        label: Text("  Play Quiz"),
        icon: Icon(FontAwesomeIcons.gamepad),
      );
    } else {
      return Container();
    }
  }

  _video() {
    // **NULL CHECKS TO AVOID ACCESSING BEFORE LOADING**
    if (sessionDetail.session.fields.sessionVideo == null) {
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
        print(metaData);
        print("Ended");
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
