import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:money_man/main.dart';
import 'package:money_man/ui/style.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        leadingWidth: 250.0,
        leading: Hero(
          tag: 'alo',
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Style.backIcon, color: Style.foregroundColor),
                SizedBox(
                  width: 5,
                ),
                Text('More',
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 17.0))
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Style.foregroundColor,
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Style.appBarColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: Style.backgroundColor,
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            GestureDetector(
              onTap: () async {
                final result = await showDialog(
                  barrierColor: Style.backgroundColor.withOpacity(0.54),
                  context: context,
                  builder: (context) =>
                      ThemeSettingDialog(currentTheme: Style.currentTheme),
                );
                if (result != null) {
                  if (result != Style.currentTheme && result != -1) {
                    //Style.currentTheme = result;
                    setState(() {
                      Style.changeTheme(result);
                    });
                    //App.restartApp(context);
                  }
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Hero(
                  tag: 'titleTheme',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Theme',
                      style: TextStyle(
                          fontFamily: Style.fontFamily,
                          color: Style.foregroundColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
                thickness: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSettingDialog extends StatelessWidget {
  final int currentTheme;

  const ThemeSettingDialog({Key key, @required this.currentTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Style.backgroundColor1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15.0),
        width: 315,
        decoration: BoxDecoration(),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Center(
              child: Text(
                'Theme',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop(0);
              },
              dense: true,
              title: Text(
                'Black',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              trailing: (currentTheme == 0)
                  ? Icon(
                      Icons.check_rounded,
                      color: Style.primaryColor,
                    )
                  : null,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop(1);
              },
              dense: true,
              title: Text(
                'White',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              trailing: (currentTheme == 1)
                  ? Icon(
                      Icons.check_rounded,
                      color: Style.primaryColor,
                    )
                  : null,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop(2);
              },
              dense: true,
              title: Text(
                'TheThemes',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              trailing: (currentTheme == 2)
                  ? Icon(
                      Icons.check_rounded,
                      color: Style.primaryColor,
                    )
                  : null,
            ),
            Container(
              //height: 150.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                width: 1,
                color: Style.foregroundColor.withOpacity(0.12),
              ))),
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(-1);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    ),
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
