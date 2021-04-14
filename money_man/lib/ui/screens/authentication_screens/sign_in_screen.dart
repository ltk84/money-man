import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  final Function changeShow;
  SignInScreen({
    this.changeShow,
  });

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool isObcure = true;
  bool show = true;
  Icon trailingIconPass = Icon(Icons.remove_red_eye);
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Not empty bitch';
                    else if (EmailValidator.validate(value) == false)
                      return 'Email not valid bitch';
                    return null;
                  },
                  onChanged: (value) => _email = value,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Not empty bitch';
                    else if (value.length < 6) return 'Longer password bitch';
                    return null;
                  },
                  onChanged: (value) => _password = value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: trailingIconPass,
                      onPressed: () => this.setState(() {
                        isObcure = !isObcure;
                        show = !show;
                        trailingIconPass = Icon(show == true
                            ? Icons.remove_red_eye
                            : Icons.receipt_long);
                      }),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  obscureText: isObcure,
                ),
                OutlinedButton(onPressed: () {}, child: Text('LOGIN')),
                OutlinedButton(onPressed: () {}, child: Text('SIGN UP')),
                OutlinedButton(onPressed: () {}, child: Text('LOGIN AS GUEST')),
                Divider(
                  thickness: 4.0,
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/facebook.jpg'),
                      fit: BoxFit.contain,
                    ),
                    title: Text('Connect with Facebook'),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/google.jpg'),
                      fit: BoxFit.fill,
                    ),
                    title: Text('Connect to Google'),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: ListTile(
                    leading: Image(
                        image: AssetImage('assets/apple.jpg'),
                        fit: BoxFit.fill,
                        height: 50),
                    title: Text('Connect to Apple'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
