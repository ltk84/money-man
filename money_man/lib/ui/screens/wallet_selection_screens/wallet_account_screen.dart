import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class SelectWalletScreen extends StatefulWidget {
  Wallet currentWallet;

  SelectWalletScreen({Key key, this.currentWallet}) : super(key: key);
  @override
  _SelectWalletScreenState createState() => _SelectWalletScreenState();
}

class _SelectWalletScreenState extends State<SelectWalletScreen> {
  // biến ví để đại diện cho wallet trong screen này
  dynamic wallet;

  @override
  void initState() {
    super.initState();
    wallet = widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant SelectWalletScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    wallet = widget.currentWallet;
  }

  @override
  Widget build(BuildContext context) {
    // biến để thao tác với database
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.appBarColor,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop(wallet);
          },
          child: Text(
            'Back',
            style: TextStyle(
              color: Style.foregroundColor,
              fontSize: 16.0,
              fontFamily: Style.fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text('Select Wallet',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,
            )),
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                child: Text(
                  'Included in Total',
                  style: TextStyle(
                      color: Style.foregroundColor.withOpacity(0.7),
                      fontSize: 15,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400),
                ),
                padding: EdgeInsets.fromLTRB(20, 25, 0, 8)),
            Expanded(
              child: StreamBuilder<List<Wallet>>(
                  stream: _firestore.walletStream,
                  builder: (context, snapshot) {
                    final listWallet = snapshot.data ?? [];
                    return ListView.builder(
                        itemCount: listWallet.length,
                        itemBuilder: (context, index) {
                          String iconData = listWallet[index].iconID;

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Style.boxBackgroundColor,
                                border: Border(
                                    top: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.12),
                                      width: 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.12),
                                      width: 0.5,
                                    ))),
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              onTap: () {
                                // khi nhấn vào -> chọn wallet -> setState cho biến wallet
                                setState(() {
                                  wallet = listWallet[index];
                                });

                                Navigator.pop(context, listWallet[index]);
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
                              trailing: (wallet != null &&
                                      wallet.name == listWallet[index].name)
                                  ? Icon(Icons.check, color: Style.primaryColor)
                                  : null,
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
