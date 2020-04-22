import 'package:flutter/material.dart';

class Description extends StatelessWidget{
  final String description;

  Description(this.description);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 22,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}