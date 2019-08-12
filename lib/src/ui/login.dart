import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(40, 30, 40, 10),
              child: Icon(
                Icons.confirmation_number,
                size: 100,
                color: Colors.deepOrangeAccent,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Text(
                'Lucky Draw',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter your Mobile Number',
                prefixIcon: Icon(Icons.call),
              ),
              maxLength: 10,
              keyboardType: TextInputType.phone,
            ),
            Container(
              child: ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
