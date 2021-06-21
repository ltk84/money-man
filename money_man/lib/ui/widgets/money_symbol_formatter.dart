import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class MoneySymbolFormatter extends StatelessWidget {
  final double text;
  final String currencyId;
  final TextStyle textStyle;
  final String digit;
  final TextAlign textAlign;
  MoneySymbolFormatter({
    Key key,
    @required this.text,
    @required this.currencyId,
    this.textStyle,
    this.digit = '',
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String finalText = formatText;

    return Text(
      finalText,
      style: textStyle,
      textAlign: textAlign,
    );
  }

  String get formatText {
    Currency currency = CurrencyService().findByCode(currencyId);
    String symbol = currency.symbol;
    bool onLeft = currency.symbolOnLeft;
    String _digit = this.digit;
    double _text = this.text;
    if (digit == '' && text < 0) {
      _digit = text.toString().substring(0, 1);
      _text = double.parse(text.toString().substring(1));
    }
    String finalText = onLeft
        ? '$_digit$symbol ' +
        MoneyFormatter(amount: _text).output.withoutFractionDigits
        : _digit +
        MoneyFormatter(amount: _text).output.withoutFractionDigits +
        ' $symbol';
    return finalText;
  }
}