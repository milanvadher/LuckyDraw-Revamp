import 'package:flutter/material.dart';
import 'package:youth_app/src/course/models/course_detail.dart';
import 'package:youth_app/src/course/pages/common_widgets/section_headiline.dart';
import 'package:youth_app/src/ui/youth_website.dart';

class DocumentLinks extends StatelessWidget{

  final List<Widget> links = [];
  final List<DocumentLink> doc_links;

  DocumentLinks(this.doc_links, BuildContext context){

    doc_links.forEach(
          (link) => links.add(
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppWebView(
                  url: link.link,
                  title: 'Website',
                ),
              ),
            );
          },
          child: Chip(
            label: Text(link.name),
            // backgroundColor: Colors.blueAccent,
            backgroundColor: Color(0xffBB86FC),
            labelStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return links.length > 0 ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeading("Links "),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 10),
          child: Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: links,
          ),
        ),
      ],
    ) : Container();
  }
}