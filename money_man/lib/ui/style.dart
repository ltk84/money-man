import 'package:flutter/material.dart';

class Style {
  static int currentTheme = 0;

  static String fontFamily = 'Montserrat';

  // Start Theme 1
  static Icon backIcon = Icon(Icons.arrow_back);
  static Color backgroundColor = Colors.black;
  //static Color backgroundColor = Color(0xFF111111);
  static Color appBarColor = Colors.grey[900];
  static Color backgroundColor1 = Color(0xFF111111);
  static Color foregroundColor = Colors.white;
  static Color foregroundColorDark = Color(0x70999999);
  static Color boxBackgroundColor = Colors.grey[900];
  static Color boxBackgroundColor2 = Color(0xFF1c1c1c);
  static Color primaryColor = Color(0xff2FB49C);
  static Color highlightPrimaryColor = Color(0xff36D1B5);

  static Color igButtonColor = Color(0xFFc65072);
  static Color fbButtonColor = Color(0xFF2c84d4);
  static Color errorColor = Colors.red[700];
  static Color warningColor = Colors.yellow[600];
  static Color expenseColor = Colors.red[600];
  static Color incomeColor = Color(0xFF76F676);
  static Color incomeColor2 = Colors.blueAccent;
  static Color runningColor = Color(0xFF51f08d);
  static Color successColor = Color(0xFF4FCC5C); // Nut Save
  // End Theme 1

  static String calculatorFontFamily = 'Montserrat';
  static Color calculatorPrimaryColor = Color(0xff22252e);
  static Color calculatorForegroundColor = Colors.white;
  static Color calculatorForegroundColor2 = Color(0xffdbdddd);
  static Color calculatorCancelButtonColor = Color(0xffb34048);
  static Color calculatorNumberButtonColor = Color(0xff282c35);
  static Color calculatorFunctionButtonColor = Color(0xff444b59);
  static Color calculatorCompleteButtonColor = Color(0xFF4FCC5C);
  static Color calculatorCalculateButtonColor = Color(0xff25b197);
  static Color calculatorBoxBackgroundColor = Color(0xff292d36);

  static List<Color> pieChartCategoryColors = [
    Color(0xFF678f8f).withOpacity(0.5),
    Color(0xFF23cc9c),
    Color(0xFF2981d9),
    Color(0xFFe3b82b),
    Color(0xFFe68429),
    Color(0xFFcf3f1f),
    Color(0xFFbf137a),
    Color(0xFF621bbf),
  ];
  static Color pieChartExtendedCategoryColor = Colors.grey;

  static Color incomeBarColor = Color(0xff53fdd7);
  static Color expenseBarColor = Color(0xffff5182);

  // Start Theme 2
  // static Color backgroundColor = Color(0xFFf0f0f0);
  // static Color backgroundColor1 = Color(0xFFEEEEEE);
  // static Color foregroundColor = Color(0xFF2e2e2e);
  // static Color foregroundColorDark = Color(0xFF111111);
  // static Color boxBackgroundColor = Color(0xFFe6e6e6);
  // static Color boxBackgroundColor2 = Color(0xFFc9c9c9);
  // static Color primaryColor = Color(0xff2FB49C);
  // static Color highlightPrimaryColor = Color(0xff36D1B5);
  //
  // static Color igButtonColor = Color(0xFFc65072);
  // static Color fbButtonColor = Color(0xFF2c84d4);
  // static Color errorColor = Colors.red[700];
  // static Color warningColor = Colors.yellow[600];
  // static Color expenseColor = Colors.red[600];
  // static Color incomeColor = Color(0xFF76F676);
  // static Color incomeColor2 = Colors.blueAccent;
  // static Color runningColor = Color(0xFF51f08d);
  // static Color successColor = Color(0xFF4FCC5C);
  // End Theme 2

  static void changeTheme(int themeCode) {
    switch (themeCode) {
      case 2:
        currentTheme = 2;
        appBarColor = Colors.grey[900];
        backgroundColor = Colors.black;
        //static Color backgroundColor = Color(0xFF111111);
        backgroundColor1 = Color(0xFF111111);
        foregroundColor = Colors.white;
        foregroundColorDark = Color(0x70999999);
        boxBackgroundColor = Colors.grey[900];
        boxBackgroundColor2 = Color(0xFF1c1c1c);
        primaryColor = Color(0xff2FB49C);
        highlightPrimaryColor = Color(0xff36D1B5);

        igButtonColor = Color(0xFFc65072);
        fbButtonColor = Color(0xFF2c84d4);
        errorColor = Colors.red[700];
        warningColor = Colors.yellow[600];
        expenseColor = Colors.red[600];
        incomeColor = Color(0xFF76F676);
        incomeColor2 = Colors.blueAccent;
        runningColor = Color(0xFF51f08d);
        successColor = Color(0xFF4FCC5C); // Nut Save
        break;
      // nay la style The tao
      case 0:
        currentTheme = 0;
        appBarColor = Color(0xff333333);
        backgroundColor = Color(0xff1a1a1a);
        backgroundColor1 = Color(0xFF111111);
        foregroundColor = Colors.white;
        foregroundColorDark = Color(0x70999999);
        boxBackgroundColor = Color(0xff333333);
        boxBackgroundColor2 = Color(0xFF333333);
        primaryColor = Color(0xff2FB49C);
        highlightPrimaryColor = Color(0xff36D1B5);

        igButtonColor = Color(0xFFc65072);
        fbButtonColor = Color(0xFF2c84d4);
        errorColor = Colors.red[700];
        warningColor = Colors.yellow[600];
        expenseColor = Colors.red[600];
        incomeColor = Color(0xFF76F676);
        incomeColor2 = Colors.blueAccent;
        runningColor = Color(0xFF51f08d);
        successColor = Color(0xFF4FCC5C); // Nut Save
        break;
      case 1:
        currentTheme = 1;
        backgroundColor = Color(0xFFf0f0f0);
        backgroundColor1 = Color(0xFFEEEEEE);
        foregroundColor = Color(0xFF2e2e2e);
        foregroundColorDark = Color(0xFF111111);
        boxBackgroundColor = Color(0xFFe6e6e6);
        appBarColor = boxBackgroundColor;
        boxBackgroundColor2 = Color(0xFFc9c9c9);
        primaryColor = Color(0xff2FB49C);
        highlightPrimaryColor = Color(0xff36D1B5);

        igButtonColor = Color(0xFFc65072);
        fbButtonColor = Color(0xFF2c84d4);
        errorColor = Colors.red[700];
        warningColor = Colors.yellow[600];
        expenseColor = Colors.red[600];
        incomeColor = Color(0xFF76F676);
        incomeColor2 = Colors.blueAccent;
        runningColor = Color(0xFF51f08d);
        successColor = Color(0xFF4FCC5C);
        break;
    }
  }
}
