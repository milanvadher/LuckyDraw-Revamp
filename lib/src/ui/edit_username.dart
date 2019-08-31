import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:lucky_draw_revamp/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class EditUserName extends StatefulWidget {
  @override
  _EditUserNameState createState() => _EditUserNameState();
}

class _EditUserNameState extends State<EditUserName> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final editUsernameFormKey = GlobalKey<FormState>();
  String username;
  Repository repository = Repository();

  void save() async {
    if (editUsernameFormKey.currentState.validate()) {
      try {
        Loading.show(context);
        editUsernameFormKey.currentState.save();
        User user = await repository.editUser(
          mobileNo: CacheData.userInfo.contactNumber,
          username: username,
        );
        CacheData.userInfo = user;
        Fluttertoast.showToast(
          msg: 'Updated Successfully',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
        );
        Loading.hide(context);
        Navigator.pop(context);
      } catch (e) {
        Loading.hide(context);
        Fluttertoast.showToast(
          msg: '$e',
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } else {
      autoValidate.sink.add(true);
    }
  }

  Widget editUsernameForm() {
    return StreamBuilder(
      initialData: false,
      stream: autoValidate,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Form(
          key: editUsernameFormKey,
          autovalidate: snapshot.data,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  initialValue: CacheData.userInfo.username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validation.username,
                  onSaved: (value) {
                    username = value;
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        save();
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    autoValidate.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            CommonWidget.authTopPortion(
              context: context,
              title: 'Update',
            ),
            editUsernameForm(),
          ],
        ),
      ),
    );
  }
}
