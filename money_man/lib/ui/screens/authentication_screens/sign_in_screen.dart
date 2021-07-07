import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/authentication_screens/forgot_password_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';

class SignInScreen extends StatefulWidget {
  final Function changeShow;
  SignInScreen({
    this.changeShow,
  });

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // biến tương tác với authentication
  final auth = FirebaseAuthService();
  // biến validate thông tin user
  final formKey = GlobalKey<FormState>();

  // email của user
  String email;
  // password của user
  String password;
  // biến điều khiển việc show password
  bool show = true;
  // icon mắt ở trailing của password field
  Icon trailingIconPass = Icon(Icons.remove_red_eye, color: Color(0x70999999));
  // biến loading
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
              elevation: 0,
              leading: CloseButton(),
              backgroundColor: Colors.grey[900],
            ),
            body: ListView(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: buildInputField(),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 80.0),
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
                            await signInWithEmailAndPassword(auth, context);
                          },
                          child: Text("LOGIN",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  wordSpacing: 2.0),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 80.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF2FB49C);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF2FB49C); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            widget.changeShow();
                          },
                          child: Text("SIGN UP",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  wordSpacing: 2.0),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF2FB49C); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) => ForgotPasswordScreen());
                          },
                          child: Text("Forgot password?",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  wordSpacing: 2.0),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            thickness: 1,
                            color: Colors.white24,
                          )),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              " OR ",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 1,
                            color: Colors.white24,
                          )),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF2c84d4);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF2c84d4); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            signInWithFacebookAccount();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SuperIcon(
                                  iconPath: 'assets/images/facebook.svg',
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 10,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  "Connect with Facebook",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      wordSpacing: 2.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFFfc4232);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFFfc4232); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            signInWithGoogleAccount();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SuperIcon(
                                  iconPath: 'assets/images/google.svg',
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 10,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  "Connect with Google",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      wordSpacing: 2.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Future signInWithFacebookAccount() async {
    // hiển thị màn hình loading
    setState(() {
      loading = true;
    });
    var result = await auth.signInWithFacebookVer2();
    // giá trị trả về code của lỗi khi xuất hiện lỗi khi đăng nhập
    // trả về login-success khi đăng nhập thành công
    if (result != null && result != 'login-success') {
      await showAlertDialog(result);
    }
    // tắt màn hình loading
    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  Future signInWithGoogleAccount() async {
    // hiển thị màn hình loading
    setState(() {
      loading = true;
    });
    var res = await auth.signInWithGoogleAccount();
    // giá trị trả về code của lỗi khi xuất hiện lỗi khi đăng nhập
    // trả về login-success khi đăng nhập thành công
    if (res != null && res != 'login-success') {
      await showAlertDialog(res);
    }
    // tắt màn hình loading
    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  Future signInWithEmailAndPassword(
      FirebaseAuthService _auth, BuildContext context) async {
    if (formKey.currentState.validate()) {
      // hiển thị màn hình loading
      setState(() {
        loading = true;
      });
      final res = await _auth.signInWithEmailAndPassword(email, password);
      // giá trị trả về code của lỗi khi xuất hiện lỗi khi đăng nhập
      // trả về login-success khi đăng nhập thành công
      if (res != null && res != 'login-success') {
        await showAlertDialog(res);
      }
      // tắt màn hình loading
      if (this.mounted)
        setState(() {
          loading = false;
        });
    }
  }

  Future<void> showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }

  Widget buildInputField() {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.white,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Email not empty';
              else if (!isNumeric(value) &&
                  EmailValidator.validate(value) == false)
                return 'Email not valid';
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white12,
                ),
              ),
              prefixIcon: Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.email, color: Colors.white, size: 25.0)),
              hintText: 'Email',
              hintStyle: TextStyle(
                color: Color(0x70999999),
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            cursorColor: Color(0xFF2FB49C),
          ),
        ),
        SizedBox(height: 5),
        Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.white,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Password is empty';
              else if (value.length < 6)
                return 'Password must longer than 6 digits';
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white12,
                ),
              ),
              prefixIcon: Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.lock, color: Colors.white, size: 25.0)),
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Color(0x70999999),
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: IconButton(
                icon: trailingIconPass,
                onPressed: () => this.setState(() {
                  show = !show;
                  trailingIconPass = Icon(
                    show == true
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: Color(0x70999999),
                  );
                }),
              ),
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            obscureText: show,
            cursorColor: Color(0xFF2FB49C),
          ),
        ),
      ],
    );
  }
}
