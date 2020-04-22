import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youth_app/src/course/models/course_detail.dart';
import 'package:youth_app/src/course/pages/common_widgets/description.dart';
import 'package:youth_app/src/course/pages/common_widgets/divider.dart';
import 'package:youth_app/src/course/pages/common_widgets/document_links.dart';
import 'package:youth_app/src/course/pages/common_widgets/section_headiline.dart';
import 'package:youth_app/src/course/pages/session_detail/session_detail.dart';
import 'package:youth_app/src/course/services/course_service.dart';


class CourseDetailPage extends StatefulWidget {
  final int courseId;

  CourseDetailPage(this.courseId);

  @override
  State<StatefulWidget> createState() {
    return CourseDetailState();
  }
}

class CourseDetailState extends State<CourseDetailPage> {
  CourseService _courseService = CourseService();
  CourseDetail course;

  @override
  void initState() {
    super.initState();
    _fetchCourse(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D1019),
      appBar: AppBar(
        title: course == null ? Text("") : Text(course.fields.courseName),
      ),
      body: course == null
          ? Center(child: CircularProgressIndicator())
          : _courseDetail(course),
    );
  }

  _courseDetail(CourseDetail course) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Description(course.fields.courseDescription),
        LineDivider(),
        SectionHeading("Categories "),
        _courseCategories(course.fields.courseCategories),
        DocumentLinks(course.fields.documentLink,context),
        SectionHeading("Sessions "),
        _sessionList(course.sessions),
      ],
    );
  }

  _sessionList(List<Session> sessions) {
    List<Widget> sessionList = [];
    sessions.forEach((session) => sessionList.add(_sessionCard(session)));
    return Column(
      children: sessionList,
    );
  }


  _sessionCard(Session session) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.maxFinite,
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.lightBlue.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _navigateToSession(course.pk, session.id),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  session.sessionName,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  DateFormat('dd-MM-yyyy').format(session.releaseDate),
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _courseCategories(List<String> categories) {
    List<Widget> chips = [];
    categories.forEach(
      (category) => chips.add(
        Chip(
          label: Text(category),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 10),
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: chips,
      ),
    );
  }



  _navigateToSession(int courseId, int sessionId){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SessionDetailPage(courseId, sessionId)));
  }
  _fetchCourse(int courseId) {
    _courseService.getCourseById(courseId).then((data) {
      setState(() {
        this.course = data;
      });
    });
  }
}
