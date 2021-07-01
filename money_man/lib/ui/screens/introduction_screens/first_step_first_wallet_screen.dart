import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'add_first_transaction_screens.dart';

class FirstStepForFirstWallet extends StatefulWidget {
  @override
  _FirstStepState createState() => _FirstStepState();
}

// tạo ví mẫu để cập nhật thông tin
class _FirstStepState extends State<FirstStepForFirstWallet> {
  Wallet wallet = Wallet(
      id: 'id',
      name: '',
      amount: -1,
      currencyID: 'USD',
      iconID: 'assets/icons/wallet_2.svg');

  // Đơn vị tiền tệ mặc định
  String currencyName = 'USD';

// Form key chứ gì :3
  static final _formKey = GlobalKey<FormState>();

// Hàm này để slide qua trang tiếp theo (Add first transaction screen)
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AddFirstTransactionScreen(
        wallet: this.wallet,
      ),
      // tạo animation
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
// Hiệu ứng trượt qua
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget build(BuildContext context) {
    // Lấy kích thước chuẩn của màn hình đang chạy hiện tại

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                // Tạo màu chia đôi cho màn hình
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              stops: [0.15, 0.05, 0.05, 0.25],
              colors: [
                Color(0xff2FB49C),
                Color(0xff2FB49C),
                Color(0xFF111111),
                Color(0xFF111111)
              ],
            )),
            child: Container(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create your',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 40,
                              ),
                            ),
                            Text(
                              'FIRST\nWALLET',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                fontSize: 40,
                              ),
                            ),
                          ],
                        ), // column
                      ),
                    ]),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    GestureDetector(
                      // Chọn avt cho ví
                      onTap: () async {
                        var data = await showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => IconPicker(),
                        );
                        if (data != null) {
                          setState(() {
                            wallet.iconID = data;
                          });
                        }
                      },
                      child: Container(
                        // Row để đặt icon của ví và chọn hình khác
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SuperIcon(
                              iconPath: wallet.iconID,
                              size: size.height * 0.13,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 250.0,
                      // Textformfield để nhập tên wallet
                      child: TextFormField(
                          autocorrect: false,
                          textAlign: TextAlign.center,
                          onChanged: (value) => wallet.name = value,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.35),
                            ),
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 250.0,
                      // Textformfield để nhập số tiền ban đầu
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          textAlign: TextAlign.center,
                          onChanged: (value) =>
                              wallet.amount = double.tryParse(value),
                          decoration: InputDecoration(
                            hintText: 'Amount',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.35),
                            ),
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(23),
                            ),
                          ),
                          style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      child: GestureDetector(
                        // Chọn đơn vị tiền tệ cho ví
                        onTap: () {
                          showCurrencyPicker(
                            theme: CurrencyPickerThemeData(
                              backgroundColor: Style.boxBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(23.0)),
                              ),
                              flagSize: 26,
                              titleTextStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 17,
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w700),
                              subtitleTextStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 15,
                                  color: Style.foregroundColor),
                            ),
                            onSelect: (value) {
                              wallet.currencyID = value.code;
                              setState(() {
                                currencyName = value.code;
                              });
                            },
                            context: context,
                            showFlag: true,
                            showCurrencyName: true,
                            showCurrencyCode: true,
                          );
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                  'Currency: $currencyName',
                                  style: TextStyle(
                                      fontFamily: Style.fontFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ))),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            )),
                      ),
                    ),
                    // Size box để căn chỉnh theo tùy màn hình
                    SizedBox(
                      height: size.height - 626,
                    ),
                    // Button để chuyển đến màn hình tiếp theo
                    Container(
                      child: ButtonTheme(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 14.0),
                        minWidth: 250.0,
                        child: RaisedButton(
                          onPressed: () {
                            // Kiểm tra hợp lệ của các text form field để hiện lên dialog thông báo
                            if (wallet.name == null || wallet.name.length == 0)
                              _showAlertDialog(
                                  "Please type wallet's name!", null);
                            else if (wallet.amount < 0)
                              _showAlertDialog(
                                  "Wallet's amount is not negative number",
                                  null);
                            else
                              Navigator.of(context).push(_createRoute());
                          },
                          color: Color(0xff2FB49C),
                          elevation: 0.0,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    // Là mấy cái note hiển thị cho cái slider á :3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ],
                )
              ]),
            ),
          ),
        ));
  }

  Future<void> _showAlertDialog(String content, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        if (title == null)
          return CustomAlert(
            content: content,
          );
        else
          return CustomAlert(
            content: content,
            title: title,
            iconPath: 'assets/images/success.svg',
            //iconPath: iconpath,
          );
      },
    );
  }
}
