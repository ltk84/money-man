
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
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
  String image;
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;
  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    }
    else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >=  fontSizeText  - 5) {
      setState(() {
        reachTop = 1;
      });
    }
    else {
      setState(() {
        reachTop = 0;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<FirebaseAuthService>(context);
    return StreamBuilder<User>(
      stream: _auth.userStream,
      builder: (context,snapshot){
        User _user = snapshot.data;
        return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
            leadingWidth: 250.0,
                 centerTitle: true,
                 backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: ClipRect(
                  child: AnimatedOpacity(
                    opacity: reachAppBar == 1 ? 1 : 0,
                    duration: Duration(milliseconds: 0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: reachTop == 1 ? 25 : 500, sigmaY: 25, tileMode: TileMode.values[0]),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                        color: Colors.grey[reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900].withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 8.0),
                child: reachTop == 0
                    ? Text('Edit your information', style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                )
                    : Text('',style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                    fontSize: 30
                ),
                ),
              ),
            ),
          body: ListView(
            children: <Widget>[
              buildInputField(),
              SizedBox(height: 30),
              Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    child: Text('CONFIRM', style: TextStyle(color: Colors.white),),
                    style: TextButton.styleFrom(backgroundColor: Colors.black),
                  ),
                  alignment: Alignment.bottomCenter,

              ),
            ],
          ),
          );
      }
    );
  }
  Widget buildInputField() {
    // FocusNode myFocusNode = new FocusNode();
    return Column(
      children: [
        SizedBox(height: 50),
        Row(
          children: <Widget>[
            Text('Username',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),)
          ],
        ),
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.black,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Username not empty';
              return null;
            },
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
            textAlign: TextAlign.left,
            onChanged: (value) => username = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_circle, size: 30,),
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
    ]
    );
  }
}

