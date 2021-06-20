import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SelectOtherSourceScreen extends StatelessWidget {
  final String title;
  final String titleAtEnd;
  final String criteria;
  final Wallet wallet;
  const SelectOtherSourceScreen({
    Key key,
    @required this.title,
    @required this.titleAtEnd,
    @required this.criteria,
    @required this.wallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        backgroundColor: Style.boxBackgroundColor,
        elevation: 0,
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            color: Style.foregroundColor,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
        SizedBox(
          height: 30,
        ),
        OtherSourceListView(
          criteria: criteria,
          wallet: wallet,
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
              Icons.money,
              color: Style.foregroundColor.withOpacity(0.54),
          ),
          title: Text(
            titleAtEnd,
            style: TextStyle(
                color: Colors.black
            ),
          ),
          trailing: Icon(
              Icons.chevron_right
          ),
        )
      ]),
    );
  }
}

class OtherSourceListView extends StatelessWidget {
  final String criteria;
  final Wallet wallet;
  const OtherSourceListView({
    Key key,
    @required this.criteria,
    @required this.wallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return FutureBuilder<List<MyTransaction>>(
        future: _firestore.getListOfTransactionWithCriteria(criteria, wallet.id),
        builder: (context, AsyncSnapshot<List<MyTransaction>> snapshot) {
          List<MyTransaction> transList = snapshot.data ?? [];
          print(snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transList.length,
                itemBuilder: (context, index) {
                  MyTransaction trans = transList[index];
                  return Container(
                    decoration: BoxDecoration(
                        //color: Style.boxBackgroundColor,
                        border: Border(
                            top: BorderSide(
                              width: 0.5,
                              color: Style.foregroundColor.withOpacity(0.12),
                            ),
                            bottom: BorderSide(
                              width: 0.5,
                              color: Style.foregroundColor.withOpacity(0.12),
                            )
                        )
                    ),
                    child: ListTile(
                      tileColor: Style.boxBackgroundColor,
                      minVerticalPadding: 20,
                      minLeadingWidth: 50,
                      onTap: () {
                        Navigator.pop(context, trans);
                      },
                      leading:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SuperIcon(
                                  iconPath: trans.category.iconID, size: 45.0
                              ),
                            ],
                          ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trans.category.name,
                            style: TextStyle(
                                color: Style.foregroundColor,
                                fontSize: 18.0,
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (trans.note != null && trans.note != '')
                            Column(
                              children: [
                                Text(
                                  trans.note,
                                  style: TextStyle(
                                      color: Style.foregroundColor.withOpacity(0.54),
                                      fontFamily: Style.fontFamily,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                  ),
                                ),
                                SizedBox(height: 4,),
                              ],
                            ),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: criteria == 'Debt'
                                          ? 'from '
                                          : 'to ',
                                      style: TextStyle(
                                        fontFamily: Style.fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                        color: Style.foregroundColor.withOpacity(0.54),
                                      ),
                                    ),
                                    TextSpan(
                                      text: trans.contact ?? 'someone',
                                      style: TextStyle(
                                        fontFamily: Style.fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Style.foregroundColor,
                                      ),
                                    )
                                  ]
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'on ',
                                      style: TextStyle(
                                        fontFamily: Style.fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                        color: Style.foregroundColor.withOpacity(0.54),
                                      ),
                                    ),
                                    TextSpan(
                                      text: DateFormat('EEEE, dd MMMM yyyy').format(trans.date),
                                      style: TextStyle(
                                        fontFamily: Style.fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Style.foregroundColor,
                                      ),
                                    )
                                  ]
                              )
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MoneySymbolFormatter(
                              text: trans.amount,
                              currencyId: wallet.currencyID,
                              textStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: criteria == 'Debt' ? Style.incomeColor2 : Style.expenseColor,
                              )
                          ),
                          Text(
                              ' left',
                              style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: Style.foregroundColor.withOpacity(0.54),
                              )
                          ),
                          MoneySymbolFormatter(
                              text: trans.extraAmountInfo,
                              currencyId: wallet.currencyID,
                              textStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: Style.foregroundColor,
                              )
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        });
  }
}
