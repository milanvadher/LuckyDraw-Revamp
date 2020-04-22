import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget{
  final String heading;

  SectionHeading(this.heading);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15, 0, 10),
      child: Text(
        heading,
        style: TextStyle(fontSize: 28, color: Colors.white),
      ),
    );
  }
}
