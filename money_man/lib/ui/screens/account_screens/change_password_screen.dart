import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/authentication_screens/forgot_password_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';

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
        leading: CloseButton(),
        elevation: 0,
        backgroundColor: Color(0xff111111),
      ),
      body: Container(
        color: Color(0xff111111),
        child: ListView(
          children: [
            Container(
                child: Text(
                  'CHANGE PASSWORD',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: Text(
                  'Enter your current password',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    leading: Icon(
                      Icons.lock,
                      color: Colors.white24,
                      size: 26,
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
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat'
                        ),
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: inValid1 ? Colors.red[700] : Colors.white12,
                                  width: 1.5,
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: inValid1 ? Colors.red[700] : Colors.white,
                                  width: 2.0,
                                )
                            ),
                            // errorBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Colors.red[700],
                            //       width: 1.5,
                            //     )
                            // ),
                            // focusedErrorBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Colors.red[700],
                            //       width: 2.0,
                            //     )
                            // ),
                            errorStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'Current password',
                            labelStyle: TextStyle(
                                color: Colors.white38,
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)
                        ),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure1 = !obscure1;
                        });
                      },
                      child: Icon(
                        obscure1 ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: Color(0x70999999),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 85.0, bottom: 20.0),
                      alignment: Alignment.topLeft,
                      child: !inValid1
                          ? Container()
                          : Text(
                              truePassword
                                  ? 'Password at least 6 characters'
                                  : 'Wrong password',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            )
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
                child: Text(
                  'Enter your new password',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 5,30, 5),
                    leading: Icon(
                      Icons.lock,
                      color: Colors.white24,
                      size: 26,
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
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat'
                        ),
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: invalid2 ? Colors.red[700] : Colors.white12,
                                  width: 1.5,
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: invalid2 ? Colors.red[700] : Colors.white,
                                  width: 2.0,
                                )
                            ),
                            // errorBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Colors.red[700],
                            //       width: 1.5,
                            //     )
                            // ),
                            // focusedErrorBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Colors.red[700],
                            //       width: 2.0,
                            //     )
                            // ),
                            errorStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'New password',
                            labelStyle: TextStyle(
                                color: Colors.white38,
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)
                        ),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      },
                      child: Icon(
                        obscure2 ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: Color(0x70999999),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 85.0, bottom: 20.0),
                      alignment: Alignment.topLeft,
                      child: !invalid2
                          ? Container()
                          : Text(
                              'Password at least 6 characers',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      )
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 5,30, 5),
                    leading: Icon(
                      Icons.lock,
                      color: Colors.white24,
                      size: 26,
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
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat'
                        ),
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: invalid3 ? Colors.red[700] : Colors.white12,
                                  width: 1.5,
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: invalid3 ? Colors.red[700] : Colors.white,
                                  width: 2.0,
                                )
                            ),
                            // errorBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Colors.red[700],
                            //       width: 1.5,
                            //     )
                            // ),
                            // focusedErrorBorder: UnderlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Colors.red[700],
                            //       width: 2.0,
                            //     )
                            // ),
                            errorStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'Confirm new password',
                            labelStyle: TextStyle(
                                color: Colors.white38,
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)
                        ),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscure3 = !obscure3;
                        });
                      },
                      child: Icon(
                        obscure3 ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: Color(0x70999999),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 85.0, bottom: 20.0),
                      alignment: Alignment.topLeft,
                      child: !invalid3
                          ? Container()
                          : Text(
                              isEqual
                                  ? 'Password at least 6 characers'
                                  : 'New password mismatch',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      )
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0),
              height: 40.0,
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.white;
                      return Color(
                          0xFF2FB49C); // Use the component's default.
                    },
                  ),
                  foregroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF2FB49C);
                      return Colors
                          .white; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () async {
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
                          barrierColor: Colors.black54,
                          builder: (BuildContext context) {
                            return CustomAlert(
                              iconPath: 'assets/images/success.svg',
                              title: 'Successfully',
                              content: 'Your password has been updated.',
                            );
                          },
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        print('vl');
                        showDialog(
                          context: context,
                          barrierColor: Colors.black54,
                          builder: (BuildContext context) {
                            return CustomAlert(
                              iconPath: 'assets/images/error.svg',
                              title: 'Oops',
                              content: 'Something was wrong,\nplease try again.',
                            );
                          },
                        );
                      }
                    } else
                      setState(() {});
                  });
                },
                child: Text("CHANGE PASSWORD",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        wordSpacing: 2.0),
                    textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0),
              height: 40.0,
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF2FB49C);
                      return Colors.white; // Use the component's default.
                    },
                  ),
                  foregroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.white;
                      return Color(0xFF2FB49C); // Use the component's default.
                    },
                  ),
                ),
                onPressed: () async {
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => ForgotPasswordScreen()
                  );
                },
                child: Text(
                    "FORGOT PASSWORD",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        wordSpacing: 2.0),
                    textAlign: TextAlign.center),
              ),
            ),
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
