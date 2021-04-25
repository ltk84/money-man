import 'package:flutter/material.dart';

ThemeData firstTheme(){
  TextTheme _firstTextTheme(TextTheme base){
    return base.copyWith(
      headline1: base.headline1.copyWith(

      ),
      headline2: base.headline2.copyWith(

      ),
      headline3: base.headline3.copyWith(

      ),
      headline4: base.headline4.copyWith(
        fontSize: 30,
        color: Colors.white,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold
      ),
      headline5: base.headline5.copyWith(

      ),
      headline6: base.headline6.copyWith(
        color: Colors.white,
        fontFamily: 'Montserrat',
        fontSize: 17.0
      ),
      subtitle1: base.subtitle1.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat'
      ),
      subtitle2: base.subtitle2.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat',
        fontSize: 15.0
      ),
      bodyText1: base.bodyText1.copyWith(

      ),
      bodyText2: base.bodyText2.copyWith(
        color: Colors.grey[400],
        fontWeight: FontWeight.w400,
        fontFamily: 'Montserrat',
        fontSize: 13.0
      ),
      caption: base.caption.copyWith(

      ),
      button: base.button.copyWith(

      ),
      overline: base.subtitle2.copyWith(

      ),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _firstTextTheme(base.textTheme),
  );
}