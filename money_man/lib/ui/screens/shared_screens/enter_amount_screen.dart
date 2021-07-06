import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:money_man/ui/style.dart';

class EnterAmountScreen extends StatefulWidget {
  @override
  _EnterAmountScreenState createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  // biến xác định việc kết thúc nhập
  var isEnd = false;
  // đầu vào của user
  var userInput = '';
  // kết quả đầu ra
  var answer = '';
  // đầu vào được format
  var userInputFormat = '';
  // đầu ra được format
  var answerFormat = '';

// mảng các nút
  final List<String> buttons = [
    'AC',
    '÷',
    '×',
    '⌫',
    '7',
    '8',
    '9',
    '-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '=',
    '0',
    '000',
    '.',
    '✓'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          color: Style.calculatorForegroundColor,
        ),
        title: Text(
          'Calculate your amount',
          style: TextStyle(
            fontFamily: Style.fontFamily,
            color: Style.calculatorForegroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Style.calculatorPrimaryColor,
        elevation: 0,
      ),
      backgroundColor: Style.calculatorPrimaryColor,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        reverse: true,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.centerRight,
                          child: Text(
                            userInput.length.toString() + '/12',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Style.calculatorForegroundColor.withOpacity(0.24),
                              fontFamily: Style.fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: 2,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.centerRight,
                          child: Text(
                            userInputFormat,
                            style: TextStyle(
                              fontSize: 25,
                              color: Style.calculatorForegroundColor,
                              fontFamily: Style.fontFamily,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(30),
                          alignment: Alignment.centerRight,
                          child: Text(
                            answerFormat,
                            style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontSize: 35,
                                color: Style.calculatorForegroundColor,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ]),
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: EdgeInsets.fromLTRB(28, 20, 20, 40),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Style.calculatorBoxBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  buildKeyOfCalculator(
                                    0,
                                    Style.calculatorForegroundColor2,
                                    Style.calculatorCancelButtonColor,
                                  ),
                                  buildKeyOfCalculator(
                                      4,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      8,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      12,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      16,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                ],
                              ),
                              Column(
                                children: [
                                  buildKeyOfCalculator(
                                      1,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                  buildKeyOfCalculator(
                                      5,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      9,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      13,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      17,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                ],
                              ),
                              Column(
                                children: [
                                  buildKeyOfCalculator(
                                      2,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                  buildKeyOfCalculator(
                                      6,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      10,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      14,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorNumberButtonColor),
                                  buildKeyOfCalculator(
                                      18,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                ],
                              ),
                              Column(
                                children: [
                                  buildKeyOfCalculator(
                                      3,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                  buildKeyOfCalculator(
                                      7,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                  buildKeyOfCalculator(
                                      11,
                                      Style.calculatorForegroundColor2,
                                      Style.calculatorFunctionButtonColor),
                                  buildKeyOfCalculator(
                                      isEnd ? 19 : 15,
                                      Style.calculatorForegroundColor2,
                                      isEnd
                                          ? Style.calculatorCompleteButtonColor
                                          : Style
                                              .calculatorCalculateButtonColor, //Color(0xff22a115) : Color(0xff25b197),
                                      2),
                                  //KeyOfCalc(19, Color(0xffdbdddd)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // xác định button được nhấn là dấu
  bool isOperator(String x) {
    if (x == '÷' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  // tính toán phép tính
  void equalPressed() {
    // Kiểm tra xem ký tự cuối cùng có phải là dấu hay không.
    var sign = ['+', '-', '*', '/',];
    sign.forEach((element) {
      if (userInput.endsWith(element))
        userInput = userInput.substring(0, userInput.length - 1);
    });
    
    String finalUserInput = userInput;
    if (finalUserInput.isEmpty) return;

    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toStringAsFixed(0);
    setState(() {
      answerFormat = MoneyFormatter(amount: double.parse(answer))
          .output
          .withoutFractionDigits;
      userInput = answer;
      userInputFormat = MoneyFormatter(amount: double.parse(userInput))
          .output
          .withoutFractionDigits;
    });
  }

  // Convert to formatter for displaying.
  convertInput() {
    final intRegex = RegExp(r'[+|\-|*|/]');
    var listString =
    intRegex.allMatches(userInput).map((m) => m.group(0)).toList();
    var listNumber = userInput.split(intRegex);
    String finalString = '';
    for (var i = 0; i < listNumber.length; i++) {
      if (listNumber[i] != '') {
        var formatNumber =
            MoneyFormatter(amount: double.tryParse(listNumber[i]))
                .output
                .withoutFractionDigits;
        if (i != listNumber.length - 1) {
          finalString += formatNumber + listString[i];
        } else {
          finalString += formatNumber;
        }
        userInputFormat = finalString;
      }
    }
  }

  // hàm xử lý khi nhấn nút
  keyOnclick(int index) {
    setState(() {
      isEnd = false;
    });
    // Nút 'C'
    if (index == 0) {
      setState(() {
        userInput = '';
        answer = '0';
        userInputFormat = '';
        answerFormat = '0';
      });
    }

    // Nút 'Delete'
    else if (index == 3) {
      {
        if (userInput.isEmpty) return;
        setState(() {
          userInput = userInput.substring(0, userInput.length - 1);
          userInputFormat = userInput;
          //convertInput();
        });
        convertInput();
      }
    }

    // Nút '='
    else if (index == 15) {
      setState(() {
        isEnd = true;
        equalPressed();
      });
    }

    // Nút 'Confirm'
    else if (index == 19) {
      if (answer != null && answer != '')
        Navigator.pop(context, answer);
    }

    // những nút khác
    else {
      setState(() {
        var sign = ['+', '-', '*', '/'];
        var input;

        // nút dấu nhân
        if (buttons[index] == '×')
          input = '*';
        // nút dấu chia
        else if (buttons[index] == '÷')
          input = '/';
        // các nút số + dấu +,-
        else
          input = buttons[index];

        // if (input == '.' && userInput.contains('.')) return;

        if (input == '.')
          return;

        if (sign.contains(input)) {
          for (var s in sign) {
            if (userInput.length == 0)
              return;
            else if (userInput.endsWith(s)) {
              if (s == input)
                return;
              else {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            }
          }
        }

        if (userInput.length < 12)
          userInput += input;

        if (userInput.length > 12)
          userInput = userInput.substring(0, 12);

        final intRegex = RegExp(r'[+|\-|*|/]');
        var listString =
            intRegex.allMatches(userInput).map((m) => m.group(0)).toList();
        var listNumber = userInput.split(intRegex);
        String finalString = '';
        for (var i = 0; i < listNumber.length; i++) {
          if (listNumber[i] != '') {
            var formatNumber =
                MoneyFormatter(amount: double.tryParse(listNumber[i]))
                    .output
                    .withoutFractionDigits;
            if (i != listNumber.length - 1) {
              finalString += formatNumber + listString[i];
            } else {
              finalString += formatNumber;
            }
            userInputFormat = finalString;
          }
        }
      });
    }
  }

  Widget buildKeyOfCalculator(int index, Color txtcolor, Color backgroundColor,
      [int flex = 1]) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          keyOnclick(index);
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor, //Color(0xff282c35),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          width: 70,
          margin: EdgeInsets.all(7),
          child: Text(
            buttons[index],
            style: TextStyle(
              fontFamily: Style.calculatorFontFamily,
              fontWeight: FontWeight.w500,
              color: txtcolor, //Color(0xffdbdddd),
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
