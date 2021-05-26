import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:math_expressions/math_expressions.dart';

class EnterAmountScreen extends StatefulWidget {
  @override
  _EnterAmountScreenState createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  var isEnd = false;
  var userInput = '';
  var answer = '';
  var userInputFormat = '';
  var answerFormat = '';
  var tempt = '';

// Array of button
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xff444b59)),
          child: Text(
            'Calculate your amount!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff22252e),
      body: Container(
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
                        userInputFormat,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      alignment: Alignment.centerRight,
                      child: Text(
                        answerFormat,
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
                    color: Color(0xff292d36),
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
                              KeyOfCalc(
                                0,
                                Color(0xffdbdddd),
                                Color(0xffb34048),
                              ),
                              KeyOfCalc(
                                  4, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  8, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  12, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  16, Color(0xffdbdddd), Color(0xff282c35)),
                            ],
                          ),
                          Column(
                            children: [
                              KeyOfCalc(
                                  1, Color(0xffdbdddd), Color(0xff444b59)),
                              KeyOfCalc(
                                  5, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  9, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  13, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  17, Color(0xffdbdddd), Color(0xff444b59)),
                            ],
                          ),
                          Column(
                            children: [
                              KeyOfCalc(
                                  2, Color(0xffdbdddd), Color(0xff444b59)),
                              KeyOfCalc(
                                  6, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  10, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  14, Color(0xffdbdddd), Color(0xff282c35)),
                              KeyOfCalc(
                                  18, Color(0xffdbdddd), Color(0xff444b59)),
                            ],
                          ),
                          Column(
                            children: [
                              KeyOfCalc(
                                  3, Color(0xffdbdddd), Color(0xff444b59)),
                              KeyOfCalc(
                                  7, Color(0xffdbdddd), Color(0xff444b59)),
                              KeyOfCalc(
                                  11, Color(0xffdbdddd), Color(0xff444b59)),
                              KeyOfCalc(
                                  isEnd ? 19 : 15,
                                  Color(0xffdbdddd),
                                  isEnd ? Color(0xff22a115) : Color(0xff25b197),
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
    );
  }

  bool isOperator(String x) {
    if (x == '÷' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    print(finaluserinput.length);
    if (finaluserinput.isEmpty) return;
    // String finaluserinput = '123456+123456';

    Parser p = Parser();
    print(finaluserinput);
    Expression exp = p.parse(finaluserinput);
    print(exp);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    print(eval);
    answer = eval.toString();
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

  KeyOnclick(int index) {
    setState(() {
      isEnd = false;
    });
    print(buttons[index]);
    if (index == 0) {
      setState(() {
        userInput = '';
        answer = '0';
        userInputFormat = '';
        answerFormat = '0';
      });
    }
    // Delete Button

    else if (index == 3) {
      {
        if (userInput.isEmpty) return;
        setState(() {
          userInput = userInput.substring(0, userInput.length - 1);
          userInputFormat = userInput;
        });
      }
    }

    // Equal_to Button
    else if (index == 15) {
      setState(() {
        isEnd = true;
        equalPressed();
      });
    }

    // confirm button
    else if (index == 19) {
      Navigator.pop(context, answer);
    }

    // other buttons
    else {
      setState(() {
        var sign = ['+', '-', '*', '/'];
        var input;

        if (buttons[index] == '×')
          input = '*';
        else if (buttons[index] == '÷')
          input = '/';
        else
          input = buttons[index];
        if (input == '.' && userInput.contains('.')) return;
        if (sign.contains(input)) {
          for (var s in sign) {
            if (userInput.length == 0)
              return;
            else if (userInput.endsWith(s)) {
              if (s == input)
                return;
              else {
                userInput = userInput.substring(0, userInput.length - 1);
                print(userInput);
              }
            }
          }
        }

        userInput += input;

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
            print(userInput);
          }
        }
      });
    }
  }

  KeyOfCalc(int index, Color txtcolor, Color BgColor, [int flex = 1]) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          KeyOnclick(index);
        },
        child: Container(
          decoration: BoxDecoration(
            color: BgColor, //Color(0xff282c35),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          width: 70,
          margin: EdgeInsets.all(7),
          child: Text(
            buttons[index],
            style: TextStyle(
              color: txtcolor, //Color(0xffdbdddd),
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
