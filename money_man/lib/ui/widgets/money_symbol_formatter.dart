import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

//Text(dạng widget )hiển thị số tiền với đơn vị tiền tệ
class MoneySymbolFormatter extends StatelessWidget {
  // amount (số tiền) cần hiển thị
  final double text;
  // id đơn vị tiền tệ
  final String currencyId;
  // style của text khi trả về
  final TextStyle textStyle;
  // dấu giá trị của amount ( '-' khi amount < 0 , '+' khi amount > 0)
  final String digit;
  // vị trí của text được trả về.
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
    // text hiển thị cuối cùng(được trả về)
    String finalText = formatText;

    return Text(
      finalText,
      style: textStyle,
      textAlign: textAlign,
    );
  }

  //thiết lập text cần được hiển thị
  String get formatText {
    Currency currency = CurrencyService().findByCode(currencyId);
    //đơn vị tiền tệ
    String symbol = currency.symbol;
    //xem xét đơn vị tiền tệ được hiển thị bên trái hay phải amount
    bool onLeft = currency.symbolOnLeft;
    //dấu của amount ( '-' khi amount < 0 , '+' khi amount > 0)
    String _digit = this.digit;
    //giá trị của tiền cần hiển thị
    double _text = this.text;

    //lấy dấu của amount và lấy giá trị tuyệt đối của amount khi amount < 0;
    if (digit == '' && text < 0) {
      _digit = text.toString().substring(0, 1);
      _text = double.parse(text.toString().substring(1));
    }

    //Tạo text cần hiển thị
    String finalText = onLeft
        ? '$_digit$symbol ' +
        MoneyFormatter(amount: _text).output.withoutFractionDigits
        : _digit +
        MoneyFormatter(amount: _text).output.withoutFractionDigits +
        ' $symbol';
    return finalText;
  }
}