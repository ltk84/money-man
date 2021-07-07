import 'package:flutter/material.dart';

class Style {
  // Default theme = 0 - Black Theme.
  static int currentTheme = 0;

  // Default font family - Montserrat.
  static String fontFamily = 'Montserrat';

  // Default back icon.
  static IconData backIcon = Icons.arrow_back_ios_rounded;

  // Màu chính.
  static Color primaryColor = Color(0xff2FB49C);
  static Color highlightPrimaryColor = Color(0xff36D1B5);

  // Màu background, foreground, box.
  static Color backgroundColor = Colors.black;
  static Color appBarColor = Colors.grey[900];
  static Color backgroundColor1 = Color(0xFF111111);
  static Color foregroundColor = Colors.white;
  static Color foregroundColorDark = Color(0x70999999);
  static Color boxBackgroundColor = Colors.grey[900];
  static Color boxBackgroundColor2 = Color(0xFF1c1c1c);


  // Màu status và button.
  static Color igButtonColor = Color(0xFFc65072);
  static Color fbButtonColor = Color(0xFF2c84d4);
  static Color errorColor = Colors.red[700];
  static Color warningColor = Colors.yellow[600];
  static Color expenseColor = Colors.red[600];
  static Color incomeColor = Color(0xFF76F676);
  static Color incomeColor2 = Colors.blueAccent;
  static Color runningColor = Color(0xFF51f08d);
  static Color successColor = Color(0xFF4FCC5C);

  // Màu calculator.
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

  // Màu pie chart.
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

  // Màu bar chart.
  static Color incomeBarColor = Color(0xff53fdd7);
  static Color expenseBarColor = Color(0xffff5182);

  // Hàm đổi giao diện theo các chủ đề.
  static void changeTheme(int themeCode) {
    switch (themeCode) {
      // Black Theme.
      case 0:
        currentTheme = 0;
        backgroundColor = Colors.black;
        appBarColor = Colors.grey[900];
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
        successColor = Color(0xFF4FCC5C);
        break;

      // White Theme.
      case 1:
        currentTheme = 1;
        backgroundColor = Color(0xFFffffff);
        backgroundColor1 = Color(0xFFffffff);
        foregroundColor = Color(0xFF000000);
        foregroundColorDark = Color(0xFF111111);
        boxBackgroundColor = Color(0xFFe5e6eb);
        appBarColor = Color(0xff2cb84b);
        boxBackgroundColor2 = Color(0xFFcbccd1);
        primaryColor = Color(0xff36f800);
        highlightPrimaryColor = Color(0xff36D1B5);

        igButtonColor = Color(0xFFc65072);
        fbButtonColor = Color(0xFF2c84d4);
        errorColor = Colors.red[700];
        warningColor = Colors.yellow[600];
        expenseColor = Colors.red[600];
        incomeColor = Color(0xFF76F676);
        incomeColor2 = Colors.blueAccent;
        runningColor = Color(0xFF51f08d);
        successColor = Color(0xFF51f08d);
        break;

      // Grey Theme.
      case 2:
        currentTheme = 2;
        appBarColor = Color(0xff444444);
        backgroundColor = Color(0xff1a1a1a);
        backgroundColor1 = Color(0xFF111111);
        foregroundColor = Colors.white;
        foregroundColorDark = Color(0x70999999);
        boxBackgroundColor = Color(0xff333333);
        boxBackgroundColor2 = Color(0xFF666666);
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
