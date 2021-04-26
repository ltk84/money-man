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
        elevation: 0,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Forgot \nPassword?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Enter the email address associated \n with your account',
                      style: TextStyle(
                          fontFamily: 'Montserrat', color: Colors.grey[700]),
                    )
                  ],
                ),
                Center(
                  child: Container(
                    height: 230,
                    width: 230,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/forgotPass.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                      //shape: BoxShape.rectangle,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        'Your email',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
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
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Montserrat'),
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
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: black,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: black,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: black, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: black,
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
                Container(
                  //padding: EdgeInsets.only(left: 60),
                  child: ProgressButton.icon(
                      textStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: white),
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                            text: 'Send',
                            icon: Icon(Icons.send, color: Colors.white),
                            color: Colors.black),
                        ButtonState.loading:
                            IconedButton(text: 'Loading', color: yellow),
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
            if (res is String) {
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
            //Hàm res is String luôn là false m ơi
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
