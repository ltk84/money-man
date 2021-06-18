import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/add_wallet_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/edit_wallet_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class MyWalletScreen extends StatefulWidget {
  @override
  _MyWalletScreenState createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen>
    with TickerProviderStateMixin {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    } else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >= fontSizeText - 5) {
      setState(() {
        reachTop = 1;
      });
    } else {
      setState(() {
        reachTop = 0;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Style.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 250.0,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'alo',
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Style.foregroundColor),
                  Text('More', style: TextStyle(
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 17.0
                  )),
                ],
              ),
            ),
          ),
          //),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: AnimatedOpacity(
              opacity: reachAppBar == 1 ? 1 : 0,
              duration: Duration(milliseconds: 0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: reachTop == 1 ? 25 : 500,
                    sigmaY: 25,
                    tileMode: TileMode.values[0]),
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds:
                          reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                  color: Colors.grey[
                          reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900]
                      .withOpacity(0.2),
                  //),
                ),
              ),
            ),
          ),
          title: AnimatedOpacity(
              opacity: reachTop == 1 ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Text(
                  ''
                  'My Wallets',
                  style: TextStyle(
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 17.0))),
          actions: [
            TextButton(
              onPressed: () async {
                await showCupertinoModalBottomSheet(
                  backgroundColor: Style.boxBackgroundColor,
                  context: context,
                  builder: (context) => AddWalletScreen(),
                );
                setState(() {});
              },
              child: Text('Add', style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 17.0
              )),
            ),
          ],
        ),
        body: Container(
          color: Style.backgroundColor,
          child: StreamBuilder<List<Wallet>>(
              stream: _firestore.walletStream,
              builder: (context, snapshot) {
                final listWallet = snapshot.data ?? [];
                listWallet.removeWhere((element) => element.id == 'Total');
                print('stream ' + listWallet.length.toString());
                return ListView.builder(
                    controller: _controller,
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: listWallet.length,
                    itemBuilder: (context, index) {
                      String iconData = listWallet[index].iconID;
                      // IconData iconData = Icons.wallet_giftcard;

                      return Column(
                        children: [
                          index == 0
                              ? Container(
                                  //padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 8.0),
                                  child: reachTop == 0
                                      ? Text('My Wallets',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Style.foregroundColor,
                                              fontFamily: Style.fontFamily,
                                              fontWeight: FontWeight.bold
                                          )
                                  )
                                      : Text('',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Style.foregroundColor,
                                          fontFamily: Style.fontFamily,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                )
                              : Container(),
                          index == 0
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    'Included in Total',
                                    style: TextStyle(
                                        color: Style.foregroundColor.withOpacity(0.7),
                                        fontSize: 18,
                                        fontFamily: Style.fontFamily,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : Container(),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Style.boxBackgroundColor,
                                border: Border(
                                    top: BorderSide(
                                      color: Style.foregroundColor.withOpacity(0.12),
                                      width: 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: Style.foregroundColor.withOpacity(0.12),
                                      width: 0.5,
                                    ))),
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              onTap: () async {
                                await showCupertinoModalBottomSheet(
                                  backgroundColor: Style.boxBackgroundColor,
                                  context: context,
                                  builder: (context) => EditWalletScreen(
                                      wallet: listWallet[index]),
                                );
                                setState(() {});
                              },
                              leading:
                                  SuperIcon(iconPath: iconData, size: 35.0),
                              title: Text(
                                listWallet[index].name,
                                style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // subtitle: Text(
                              //   listWallet[index].amount.toString(),
                              //   style: TextStyle(
                              //     color: foregroundColor,
                              //     fontFamily: fontFamily,
                              subtitle: MoneySymbolFormatter(
                                text: listWallet[index].amount,
                                currencyId: listWallet[index].currencyID,
                                textStyle: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }),
        ),
      ),
    );
  }
}
