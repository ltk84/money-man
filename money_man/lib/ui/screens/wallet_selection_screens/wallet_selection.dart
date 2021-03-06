import 'package:flutter/cupertino.dart';
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

class WalletSelectionScreen extends StatefulWidget {
  String id = '';
  WalletSelectionScreen({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _WalletSelectionScreenState createState() => _WalletSelectionScreenState();
}

class _WalletSelectionScreenState extends State<WalletSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // biến thao tác với database
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Container(
      color: Colors.transparent,
      child: Scaffold(
          backgroundColor: Style.boxBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Style.appBarColor,
            leading: CloseButton(
                color: Style.foregroundColor,
                onPressed: () {
                  Navigator.of(context).pop(widget.id);
                }),
            title: Text('Select Wallet',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  // lấy wallet bằng id
                  Wallet wallet = await _firestore.getWalletByID(widget.id);
                  // dẫn vào screen edit wallet
                  var res = await showCupertinoModalBottomSheet(
                    backgroundColor: Style.boxBackgroundColor,
                    context: context,
                    builder: (context) => EditWalletScreen(wallet: wallet),
                  );
                  if (res != null)
                    setState(() {
                      widget.id = res;
                    });
                },
                child: Text('Edit',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )),
              ),
            ],
          ),
          body: Container(
            color: Style.backgroundColor1,
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'My Wallets',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Style.foregroundColor.withOpacity(0.38),
                      ),
                    ),
                  ),
                ),
                buildDisplayWallet(),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                    height: 40,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        // add wallet
                        final res = await showCupertinoModalBottomSheet(
                            backgroundColor: Style.boxBackgroundColor,
                            context: context,
                            builder: (context) => AddWalletScreen());
                        if (res != null)
                          setState(() {
                            widget.id = res;
                          });
                      },
                      child: Text("ADD NEW WALLET",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              wordSpacing: 2.0),
                          textAlign: TextAlign.center),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.white;
                            return Color(
                                0xFF2FB49C); // Use the component's default.
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Color(0xFF2FB49C);
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  // build phần display các wallet
  Widget buildDisplayWallet() {
    // biến thao tác với database
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Expanded(
      child: StreamBuilder<List<Wallet>>(
          stream: _firestore.walletStream,
          builder: (context, snapshot) {
            final listWallet = snapshot.data ?? [];
            return ListView.builder(
                itemCount: listWallet.length,
                itemBuilder: (context, index) {
                  String iconData = listWallet[index].iconID;

                  // nếu wallet là wallet đang được chọn thì trailing có icon dấu tích
                  // còn không phải thì không có
                  return widget.id == listWallet[index].id
                      ? GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Style.boxBackgroundColor,
                                border: Border(
                                    top: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.12),
                                      width: index == 0 ? 0.5 : 0,
                                    ),
                                    bottom: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.12),
                                      width: 0.5,
                                    ))),
                            child: ListTile(
                              leading: SuperIcon(
                                iconPath: iconData,
                                size: 40.0,
                              ),
                              title: Text(
                                listWallet[index].name,
                                style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: MoneySymbolFormatter(
                                checkOverflow: false,
                                text: listWallet[index].amount,
                                currencyId: listWallet[index].currencyID,
                                textStyle: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: Icon(Icons.check_rounded,
                                  color: Style.primaryColor),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Style.boxBackgroundColor,
                                border: Border(
                                    top: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.12),
                                      width: index == 0 ? 0.5 : 0,
                                    ),
                                    bottom: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.12),
                                      width: 0.5,
                                    ))),
                            child: ListTile(
                              onTap: () async {
                                widget.id = listWallet[index].id;
                                // update wallet đang được chọn
                                final updateWalletId = await _firestore
                                    .updateSelectedWallet(widget.id);
                                Navigator.pop(context, updateWalletId);
                              },
                              leading: SuperIcon(
                                iconPath: iconData,
                                size: 40.0,
                              ),
                              title: Text(
                                listWallet[index].name,
                                style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: MoneySymbolFormatter(
                                checkOverflow: false,
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
                        );
                });
          }),
    );
  }
}
