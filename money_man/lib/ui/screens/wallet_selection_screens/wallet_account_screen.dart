import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class SelectWalletAccountScreen extends StatefulWidget {
  Wallet wallet;

  SelectWalletAccountScreen({Key key, this.wallet}) : super(key: key);
  @override
  _SelectWalletAccountScreenState createState() =>
      _SelectWalletAccountScreenState();
}

class _SelectWalletAccountScreenState extends State<SelectWalletAccountScreen> {
  dynamic _wallet;

  @override
  void initState() {
    super.initState();
    _wallet = widget.wallet;
  }

  @override
  void didUpdateWidget(covariant SelectWalletAccountScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _wallet = widget.wallet;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop(_wallet);
          },
          child: Text(
            'Back',
            style: TextStyle(
              color: Style.foregroundColor,
              fontSize: 16.0,
              fontFamily: Style.fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),),
        title: Text('Select Wallet',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,)),
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
                    listWallet.removeWhere((element) => element.id == 'Total');
                    print('stream ' + listWallet.length.toString());
                    return ListView.builder(
                        itemCount: listWallet.length,
                        itemBuilder: (context, index) {
                          String iconData = listWallet[index].iconID;
                          // IconData iconData = Icons.wallet_giftcard;

                          return Container(
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
                              onTap: () {
                                setState(() {
                                  _wallet = listWallet[index];
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
                                text: listWallet[index].amount,
                                currencyId: listWallet[index].currencyID,
                                textStyle: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: (_wallet != null &&
                                  _wallet.name == listWallet[index].name)
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