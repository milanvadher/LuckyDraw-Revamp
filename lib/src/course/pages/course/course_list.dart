import 'package:flutter/material.dart';
import 'package:youth_app/src/course/models/courses.dart';
import 'package:youth_app/src/course/pages/course_detail/course_detail.dart';
import 'package:youth_app/src/course/services/course_service.dart';

class CourseListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CourseListState();
  }
}

class CourseListState extends State<CourseListPage> {
  CourseService _courseService = CourseService();
  List<Course> courses;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
     appBar: AppBar(
        elevation: 8,
        iconTheme: IconThemeData(color: Color(0xffffffff)),
        backgroundColor: Color(0xff272727),
        title: Text("Courses",style: TextStyle(color: Colors.white),),
      ),
      body: courses == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _courseList(),
    );
  }

  _courseList() {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return _courseCard(courses[index]);
        });
  }

  _courseCard(Course course) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      // decoration: new BoxDecoration(
      //   border: new Border.all(color: Colors.lightBlue.shade300),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      width: double.maxFinite,
      child: InkWell(
        onTap: () => _navigateToCourse(course),
        child: Card(
          color: Color(0xff272727),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      course.courseName,
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      course.courseDescription,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    )
                  ],
                ),

                course.completed ? Icon(Icons.done, color: Colors.green,size: 30,) :Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navigateToCourse(Course course) {
//    print(course.fields.courseName);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CourseDetailPage(course.pk)));
  }

  fetchCourses() async {
    _courseService.getCourseList().then((data) {
      setState(() {
        this.courses = data;
      });
    });
    print(courses);
  }
}
