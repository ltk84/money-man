import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';
import 'package:provider/provider.dart';

class AccountInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccountInformation();
  }
}

class AccountInformation extends StatefulWidget {
  @override
  _AccountInformation createState() => _AccountInformation();
}

class _AccountInformation extends State<AccountInformation> {
  String username;
  bool invalid = false;
  Widget InputTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xff333333), borderRadius: BorderRadius.circular(17)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'User name:',
              style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_rounded,
              color: white,
              size: 30,
            ),
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.white,
              ),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    username = val;
                  });

                  print(username);
                },
                style: TextStyle(
                    color: white, fontSize: 20, fontFamily: 'Montserrat'),
                autocorrect: false,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5)),
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              child: !invalid
                  ? Container()
                  : Text(
                      'This field can not empty',
                      style: TextStyle(color: Colors.red),
                    ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("What is your name?"),
        backgroundColor: Color(0xff2FB49C),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        color: Color(0xFF111111),
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                //buildInputField(),
                Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      height: 200,
                      width: 200,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: yellow),
                      child: Text(
                        username == null || username.length == 0
                            ? 'A'
                            : username[0].toUpperCase(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 125,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900),
                      ),
                      alignment: Alignment.center),
                ),
                InputTile(context),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xff555555)),
                  child: GestureDetector(
                    onTap: () {
                      print("tap");
                      if (username == null || username.length == 0) {
                        print("false");
                        setState(() {
                          invalid = true;
                        });
                      } else {
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (_) {
                        //   _auth.currentUser.updateProfile(
                        //     displayName: username,
                        //   );
                        //   return FirstStep();
                        // }));
                        _auth.currentUser.updateProfile(
                          displayName: username,
                        );
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => FirstStep()));
                      }
                    },
                    child: Text(
                      'CONFIRM',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Đây là cái cũ, không xài, nhưng để cho có kỷ niệm.
  Widget buildInputField() {
    final _auth = Provider.of<FirebaseAuthService>(context);
    return StreamBuilder<User>(
        stream: _auth.userStream,
        builder: (context, snapshot) {
          User _user = snapshot.data;
          return Column(children: [
            SizedBox(height: 50),
            Row(
              children: <Widget>[
                Text(
                  'Username',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Theme(
              data: Theme.of(context).copyWith(
                // override textfield's icon color when selected
                primaryColor: Colors.black,
              ),
              child: TextFormField(
                initialValue:
                    (_user.displayName != '' && _user.displayName != null)
                        ? _user.displayName
                        : (_user.phoneNumber != null ? _user.phoneNumber : ''),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Username not empty';
                  return null;
                },
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
                onChanged: (value) => username = value,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                  ),
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                cursorColor: Colors.black,
              ),
            ),
            SizedBox(height: 10)
          ]);
        });
  }
}
