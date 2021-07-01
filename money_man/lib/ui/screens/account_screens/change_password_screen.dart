import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/authentication_screens/forgot_password_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';

// Màn hình thay đổi mật khẩu
class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  final _auth = FirebaseAuthService();
  // Biến kiểm tra việc nhập liệu của nhập mật khẩu hiện tại
  bool inValid1 = false;
  // Biến kiểm tra việc nhập liệu của nhập mật khẩu muốn đổi
  bool invalid2 = false;
  // Biến kiểm tra việc nhập liệu của nhập xác nhận mật khẩu muốn đổi
  bool invalid3 = false;
  // Biến kiểm tra việc xác nhận mật khẩu muốn đổi giống nhau hay không
  bool isEqual = true;
  // Xác nhận mật khẩu hiện tại chính xác
  bool truePassword = true;
  // LƯu trữ thông tin các text nhập vào từ mật khẩu hiện tại, muốn đổi, xác nhận
  String field1, field2, field3;
  // Biến hiển thị việc che hay không che cho thứ tự mật khẩu hiện tại, muốn đổi, xác nhận
  bool obscure1 = true;
  bool obscure2 = true;
  bool obscure3 = true;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: ListView(
          children: [
            Container(
                child: Text(
              'CHANGE PASSWORD',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 24.0,
                color: Style.foregroundColor,
              ),
              textAlign: TextAlign.center,
            )),
            Container(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: Text(
                  'Enter your current password',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Style.foregroundColor,
                  ),
                  textAlign: TextAlign.center,
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
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
                      color: Style.foregroundColor.withOpacity(0.24),
                      size: 25,
                    ),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Style.foregroundColor,
                      ),
                      // Nhập mật khẩu hiện tại
                      child: TextFormField(
                        obscureText: obscure1,
                        cursorColor: Style.foregroundColor,
                        onChanged: (val) {
                          setState(() {
                            field1 = val;
                          });
                        },
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: Style.fontFamily),
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: inValid1
                                  ? Style.errorColor
                                  : Style.foregroundColor.withOpacity(0.12),
                              width: 1.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: inValid1
                                  ? Style.errorColor
                                  : Style.foregroundColor,
                              width: 2.0,
                            )),
                            errorStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'Current password',
                            labelStyle: TextStyle(
                                color: Style.foregroundColor.withOpacity(0.24),
                                fontFamily: Style.fontFamily,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      ),
                    ),
                    trailing: GestureDetector(
                      //Hiện mật khẩu
                      onTap: () {
                        setState(() {
                          obscure1 = !obscure1;
                        });
                      },
                      child: Icon(
                        obscure1
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Style.foregroundColorDark,
                      ),
                    ),
                  ),
                  //Hiển thị việc nhập đúng mật khẩu hay chưa, nếu chưa thì hiện luôn cái lỗi
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
                                color: Style.errorColor,
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            ))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(40, 15, 40, 0),
                child: Text(
                  'Enter your new password',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Style.foregroundColor,
                  ),
                  textAlign: TextAlign.center,
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
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
                      color: Style.foregroundColor.withOpacity(0.24),
                      size: 25,
                    ),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Style.foregroundColor,
                      ),
                      // Nhập mật khẩu mới
                      child: TextFormField(
                        obscureText: obscure2,
                        cursorColor: Style.foregroundColor,
                        onChanged: (val) {
                          setState(() {
                            field2 = val;
                          });
                        },
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: Style.fontFamily),
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: invalid2
                                  ? Style.errorColor
                                  : Style.foregroundColor.withOpacity(0.12),
                              width: 1.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: invalid2
                                  ? Style.errorColor
                                  : Style.foregroundColor,
                              width: 2.0,
                            )),
                            errorStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'New password',
                            labelStyle: TextStyle(
                                color: Style.foregroundColor.withOpacity(0.24),
                                fontFamily: Style.fontFamily,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      ),
                    ),
                    trailing: GestureDetector(
                      // Hiện thị mật khậu
                      onTap: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      },
                      child: Icon(
                        obscure2
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Style.foregroundColorDark,
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
                                color: Style.errorColor,
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            )),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    leading: Icon(
                      Icons.lock,
                      color: Style.foregroundColor.withOpacity(0.24),
                      size: 25,
                    ),
                    title: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Style.foregroundColor,
                      ),
                      // Nhập xác nhận mật khẩu
                      child: TextFormField(
                        obscureText: obscure3,
                        cursorColor: Style.foregroundColor,
                        onChanged: (val) {
                          setState(() {
                            field3 = val;
                          });
                        },
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: Style.fontFamily),
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: invalid3
                                  ? Style.errorColor
                                  : Style.foregroundColor.withOpacity(0.12),
                              width: 1.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: invalid3
                                  ? Style.errorColor
                                  : Style.foregroundColor,
                              width: 2.0,
                            )),
                            errorStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                            labelText: 'Confirm new password',
                            labelStyle: TextStyle(
                                color: Style.foregroundColor.withOpacity(0.24),
                                fontFamily: Style.fontFamily,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      ),
                    ),
                    trailing: GestureDetector(
                      // hiện mật khẩu
                      onTap: () {
                        setState(() {
                          obscure3 = !obscure3;
                        });
                      },
                      child: Icon(
                        obscure3
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Style.foregroundColorDark,
                      ),
                    ),
                  ),
                  // Nếu nhập sai, không đủ ký tự, thì hiện lên cái này
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
                                color: Style.errorColor,
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            ))
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.white;
                      return Color(0xFF2FB49C); // Use the component's default.
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF2FB49C);
                      return Colors.white; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () async {
                  setState(() async {
                    // Kiểm tra mật khẩu đúng hay k
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
                          barrierColor: Style.backgroundColor.withOpacity(0.54),
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
                          barrierColor: Style.backgroundColor.withOpacity(0.54),
                          builder: (BuildContext context) {
                            return CustomAlert(
                              iconPath: 'assets/images/error.svg',
                              title: 'Oops',
                              content:
                                  'Something was wrong,\nplease try again.',
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
                        fontFamily: Style.fontFamily,
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF2FB49C);
                      return Colors.white; // Use the component's default.
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
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
                      builder: (context) => ForgotPasswordScreen());
                },
                child: Text("FORGOT PASSWORD",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: Style.fontFamily,
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
