import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// Màn hình trung gian, chuyển tiếp từ màn hình first step kia
class AddFirstTransactionScreen extends StatelessWidget {
  final Wallet wallet;

  const AddFirstTransactionScreen({Key key, this.wallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.6, 0.1],
          colors: [Color(0xFF111111), Color(0xff2FB49C)],
        )),
        child: Column(
          // Căn tất cả về end để cái nút ở dưới nó trùng với trang trước đó
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PURCHASE',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: size.height * 0.05 * 4 / 3,
                    ),
                  ),
                  Text(
                    'Your first',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    'Transaction!',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(top: size.height * 0.09),
              child: Align(
                  alignment: Alignment.center,
                  child: SuperIcon(
                    iconPath: 'assets/icons/money_in.svg',
                    size: 180.0,
                  )),
            ),
            SizedBox(
              height: size.height * 0.1085,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                    minWidth: 250.0,
                    child: RaisedButton(
                      // Chuyển hướng đến màn hình Home khi tạo ví thành công
                      onPressed: () async {
                        final firestore = Provider.of<FirebaseFireStoreService>(
                            context,
                            listen: false);
                        await firestore.addFirstWallet(wallet);
                        await firestore.setTheme(0);

                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: HomeScreen(),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      color: Color(0xff2FB49C),
                      elevation: 0.0,
                      child: Text(
                        'Add first transaction',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
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
                SizedBox(
                  height: 5.0,
                ),
                // Hàng này để hiển thị cái slide chứ gì :3
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.4)),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
