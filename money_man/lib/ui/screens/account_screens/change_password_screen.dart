import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  final _auth = FirebaseAuthService();
  bool inValid1 = false;
  bool invalid2 = false;
  bool invalid3 = false;
  bool isEqual = true;
  bool truePassword = true;
  String field1, field2, field3;
  bool obscure1 = true;
  bool obscure2 = true;
  bool obscure3 = true;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change Password"),
        elevation: 0,
        backgroundColor: Color(0xff333333),
      ),
      body: Container(
        color: Color(0xff111111),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(17)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Current password:',
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.vpn_key_outlined,
                      color: white,
                      size: 30,
                    ),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.white,
                      ),
                      child: TextFormField(
                        obscureText: obscure1,
                        cursorColor: white,
                        onChanged: (val) {
                          setState(() {
                            field1 = val;
                          });
                        },
                        style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                        autocorrect: false,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure1 = !obscure1;
                        });
                      },
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: obscure1 ? white : black,
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      child: !inValid1
                          ? Container()
                          : Text(
                              truePassword
                                  ? 'Password at least 8 characters'
                                  : 'Wrong password',
                              style: TextStyle(color: Colors.red),
                            ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                color: white,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(17)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'New password:',
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      },
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: obscure2 ? white : black,
                      ),
                    ),
                    leading: Icon(
                      Icons.vpn_key,
                      color: white,
                      size: 30,
                    ),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.white,
                      ),
                      child: TextFormField(
                        obscureText: obscure2,
                        cursorColor: white,
                        onChanged: (val) {
                          setState(() {
                            field2 = val;
                          });
                        },
                        style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                        autocorrect: false,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      child: !invalid2
                          ? Container()
                          : Text(
                              'Password at least 6 characers',
                              style: TextStyle(color: Colors.red),
                            )),
                  ListTile(
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure3 = !obscure3;
                        });
                      },
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: obscure3 ? white : black,
                      ),
                    ),
                    leading: Icon(
                      Icons.vpn_key,
                      color: white,
                      size: 30,
                    ),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.white,
                      ),
                      child: TextFormField(
                        obscureText: obscure3,
                        cursorColor: white,
                        onChanged: (val) {
                          setState(() {
                            field3 = val;
                          });
                        },
                        style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                        autocorrect: false,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      child: !invalid3
                          ? Container()
                          : Text(
                              isEqual
                                  ? 'Password at least 6 characers'
                                  : 'New password mismatch',
                              style: TextStyle(color: Colors.red),
                            ))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                //TODO: Validate va change password
                setState(() async {
                  // Kiểm tra mật khẩu đúng hay k
                  // Validate field 1
                  if (field1 == null || field1.length < 6) {
                    inValid1 = true;
                    print('validate1');
                  } else {
                    truePassword = await _auth.validatePassword(field1);
                    if (!truePassword) {
                      inValid1 = true;
                      print('false');
                    } else
                      inValid1 = false;
                  }

                  // validate field 2
                  if (field2 == null || field2.length < 6)
                    invalid2 = true;
                  else
                    invalid2 = false;

                  // So sánh field 2 và field 3

                  // validate field 3
                  if (field3 == null || field3.length < 6)
                    invalid3 = true;
                  else {
                    if (field2 != field3) {
                      isEqual = false;
                      invalid3 = true;
                    } else {
                      isEqual = true;
                      invalid3 = false;
                    }
                  }

                  // Nếu tất cả đều hợp lệ
                  if (!(inValid1 || invalid2 || invalid3)) {
                    try {
                      print("dm");
                      await _auth.updatePassword(field2);
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert(context, 'Congratulation',
                              'Your password updated successfully');
                        },
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('vl');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert(context, 'So sorry...',
                              'There is some mistake hear');
                        },
                      );
                    }
                  } else
                    setState(() {});
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff2FB49C),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Change password',
                  style: TextStyle(
                      color: white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Forget password',
                  style: TextStyle(
                      color: Color(0xff2FB49C),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

AlertDialog alert(context, title, mess) {
  return AlertDialog(
    title: Text(
      title,
      style: TextStyle(color: black, fontWeight: FontWeight.w700),
    ),
    content: Text(
      mess,
      style: TextStyle(color: black, fontWeight: FontWeight.w500),
    ),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
