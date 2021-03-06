import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // email của user
  String email;
  // biến đẻ validate email của user
  final formKey = GlobalKey<FormState>();
  // trạng thái của nút
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        elevation: 0,
        backgroundColor: Style.backgroundColor1,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Style.foregroundColor,
                    fontSize: 32,
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter the email address associated \n with your account',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 60.0),
                    child: SuperIcon(
                      iconPath: 'assets/images/email.svg',
                      size: 150,
                    )),
                SizedBox(height: 20),
                Container(
                  height: 80.0,
                  width: 300,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Style.foregroundColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email not empty';
                        else if (EmailValidator.validate(value) == false)
                          return 'Email not valid';
                        return null;
                      },
                      textAlign: TextAlign.start,
                      onChanged: (value) => email = value,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: Style.foregroundColor.withOpacity(0.7),
                        ),
                        errorStyle: TextStyle(
                            color: Style.errorColor,
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Style.foregroundColor,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Style.errorColor, width: 2.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Style.foregroundColor,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color: Style.foregroundColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Style.foregroundColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                    ),
                  ),
                ),
                Container(
                  child: ProgressButton.icon(
                      radius: 10.0,
                      height: 40.0,
                      textStyle: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.0,
                          color: Colors.white),
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                            text: 'Verify',
                            icon: Icon(Icons.verified_user,
                                color: Colors.white, size: 20.0),
                            color: Style.primaryColor),
                        ButtonState.loading: IconedButton(
                            text: 'Loading',
                            color: Style.primaryColor.withOpacity(0.1)),
                        ButtonState.fail: IconedButton(
                            text: 'Failed',
                            icon: Icon(Icons.cancel,
                                color: Colors.white, size: 20.0),
                            color: Style.errorColor),
                        ButtonState.success: IconedButton(
                            text: 'Success',
                            icon: Icon(Icons.check_circle,
                                color: Colors.white, size: 20.0),
                            color: Style.successColor)
                      },
                      onPressed: onPressedIconWithText,
                      state: stateTextWithIcon),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onPressedIconWithText() async {
    bool ok = true;
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        {
          stateTextWithIcon = ButtonState.loading;

          if (formKey.currentState.validate()) {
            final _auth = FirebaseAuthService();
            final res = await _auth.resetPassword(email);
            if (res is String) {
              String error = "";
              switch (res) {
                case 'invalid-email':
                  error = 'Email is invalid';
                  setState(
                    () {
                      ok = false;
                    },
                  );
                  break;
                case 'user-not-found':
                  error = 'Email not registered yet';
                  setState(
                    () {
                      ok = false;
                    },
                  );
                  break;
                default:
                  setState(
                    () {
                      ok = false;
                    },
                  );
              }
              await showAlertDialog(error);
            }
          } else {
            stateTextWithIcon = ButtonState.idle;
            return;
          }
          setState(
            () {
              stateTextWithIcon = ok ? ButtonState.success : ButtonState.fail;
            },
          );
          break;
        }
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(
      () {
        stateTextWithIcon = stateTextWithIcon;
      },
    );
  }

  Future<void> showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
