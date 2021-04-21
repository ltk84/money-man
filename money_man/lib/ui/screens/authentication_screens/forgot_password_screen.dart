import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email;

  final _formKey = GlobalKey<FormState>();

  ButtonState stateOnlyText = ButtonState.idle;

  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: yellow,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Forgot password',
          style: TextStyle(fontFamily: 'Montserrat', color: black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                'Your email',
                style: TextStyle(
                    color: yellow,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              child: Theme(
                data: Theme.of(context).copyWith(
                  // override textfield's icon color when selected
                  primaryColor: Colors.yellow,
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email not empty';
                      else if (EmailValidator.validate(value) == false)
                        return 'Email not valid';
                      return null;
                    },
                    textAlign: TextAlign.start,
                    onChanged: (value) => _email = value,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: yellow,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: yellow,
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
            ),
            SizedBox(height: 40),
            /*OutlinedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final _auth = FirebaseAuthService();
                    final res = await _auth.resetPassword(_email);
                    if (res is String) {
                      String error = "";
                      switch (res) {
                        case 'invalid-email':
                          error = 'Email is invalid';
                          break;
                        case 'user-not-found':
                          error = 'email not registered yet';
                          break;
                        default:
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error)));
                    }
                  }
                },
                child: Text('Send code to email'))*/
            ProgressButton.icon(iconedButtons: {
              ButtonState.idle: IconedButton(
                  text: 'Send',
                  icon: Icon(Icons.send, color: Colors.white),
                  color: Colors.deepPurple.shade500),
              ButtonState.loading: IconedButton(
                  text: 'Loading', color: Colors.deepPurple.shade700),
              ButtonState.fail: IconedButton(
                  text: 'Failed! Try again.',
                  icon: Icon(Icons.cancel, color: Colors.white),
                  color: Colors.red.shade300),
              ButtonState.success: IconedButton(
                  text: 'Success',
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  color: Colors.green.shade400)
            }, onPressed: onPressedIconWithText, state: stateTextWithIcon),
          ],
        ),
      ),
    );
  }

  void onPressedIconWithText() async {
    bool ok = true;
    print('click');
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        {
          stateTextWithIcon = ButtonState.loading;
          print('0');

          if (_formKey.currentState.validate()) {
            final _auth = FirebaseAuthService();
            final res = await _auth.resetPassword(_email);
            print('sent');
            //if (res is String) {
            if (true) {
              String error = "";
              switch (res) {
                case 'invalid-email':
                  error = 'Email is invalid';
                  print('1');
                  setState(
                    () {
                      ok = false;
                    },
                  );
                  break;
                case 'user-not-found':
                  error = 'email not registered yet';
                  print('2');
                  setState(
                    () {
                      ok = false;
                    },
                  );
                  break;
                default:
                  print('4');
                  setState(
                    () {
                      ok = false;
                    },
                  );
              }
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
            } else
              print('bug o day');
          } else {
            print('3');
            stateTextWithIcon = ButtonState.idle;

            return;
          }
          print(ok);
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
}
