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
    String finalText = onLeft
        ? '$digit$symbol ' +
            MoneyFormatter(amount: text).output.withoutFractionDigits
        : digit +
            MoneyFormatter(amount: text).output.withoutFractionDigits +
            ' $symbol';
    return finalText;
  }
}
