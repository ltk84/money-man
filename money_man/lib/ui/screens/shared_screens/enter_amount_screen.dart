import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/ui/widgets/buttonCalculator.dart';
import 'package:math_expressions/math_expressions.dart';

class EnterAmountScreen extends StatefulWidget {
  @override
  _EnterAmountScreenState createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  var userInput = '';
  var answer = '';
  var userInputFormat = '';
  var answerFormat = '';
  var tempt = '';

// Array of button
  final List<String> buttons = [
    'C',
    '÷',
    'x',
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Calculator"),
      ), //AppBar
      backgroundColor: Colors.white38,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        userInputFormat,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        answerFormat,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisExtent: 60),
                  itemBuilder: (BuildContext context, int index) {
                    // Clear Button
                    if (index == 0) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput = '';
                            answer = '0';
                            userInputFormat = '';
                            answerFormat = '0';
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.blue[50],
                        textColor: Colors.black,
                      );
                    }

                    // Delete Button
                    else if (index == 3) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput =
                                userInput.substring(0, userInput.length - 1);
                            userInputFormat = userInput;
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.blue[50],
                        textColor: Colors.black,
                      );
                    }

                    // Equal_to Button
                    else if (index == 15) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.orange[700],
                        textColor: Colors.white,
                      );
                    }

                    // other buttons
                    else {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            var sign = ['+', '-', '*', '/'];
                            var input;

                            if (buttons[index] == 'x')
                              input = '*';
                            else if (buttons[index] == '÷')
                              input = '/';
                            else
                              input = buttons[index];

                            if (sign.contains(input)) {
                              for (var s in sign) {
                                if (userInput.length == 0)
                                  return;
                                else if (userInput.endsWith(s)) {
                                  if (s == input)
                                    return;
                                  else {
                                    userInput = userInput.substring(
                                        0, userInput.length - 1);
                                    print(userInput);
                                  }
                                }
                              }
                            }

                            userInput += input;

                            final intRegex = RegExp(r'[+|\-|*|/]');
                            var listString = intRegex
                                .allMatches(userInput)
                                .map((m) => m.group(0))
                                .toList();
                            var listNumber = userInput.split(intRegex);
                            String finalString = '';
                            for (var i = 0; i < listNumber.length; i++) {
                              if (listNumber[i] != '') {
                                var formatNumber = MoneyFormatter(
                                        amount: double.tryParse(listNumber[i]))
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
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? Colors.blueAccent
                            : Colors.white,
                        textColor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.black,
                      );
                    }
                  }), // GridView.builder
            ),
          ),
        ],
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
    });
  }
}
