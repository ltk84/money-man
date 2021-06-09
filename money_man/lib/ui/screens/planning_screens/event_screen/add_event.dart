
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/date_format.dart';
class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime endDate;

  MyCategory cate ;

  Wallet selectedWallet;

  String currencySymbol = 'Viet Nam Dong';

  String nameEvent;

  List<String> transactionIdList = [];
  @override
  void initState() {
    endDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    cate = MyCategory(
      id: '0',
      name: 'name',
      type: 'type',
      iconID: 'assets/icons/travel.svg',
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        title: Text('Add Event',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15.0)),
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.transparent,
            )),
        actions: [
          TextButton(
              onPressed: () async {
                if (selectedWallet == null) {
                  _showAlertDialog('Please pick your wallet!');
                } else if (nameEvent == null) {
                  _showAlertDialog('Please enter name!');
                } else if (cate == null) {
                  _showAlertDialog('Please pick category');
                } else {
                  Event event;
                  event = Event(
                    name: nameEvent,
                    endDate: endDate,
                    id: 'id',
                    iconPath: cate.iconID,
                    isFinished: (endDate.year < DateTime
                        .now()
                        .year) ? true :
                    (endDate.month < DateTime
                        .now()
                        .month) ? true :
                    (endDate.day < DateTime
                        .now()
                        .day) ? true : false,
                    finishedByHand: (endDate.year < DateTime
                        .now()
                        .year) ? true :
                    (endDate.month < DateTime
                        .now()
                        .month) ? true :
                    (endDate.day < DateTime
                        .now()
                        .day) ? true : false,
                    walletId: selectedWallet.id,
                    spent: 0,
                    transactionIdList: [],
                  );
                  await _firestore.addEvent(event, selectedWallet);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )),
        ],
      ),
      body: Container(
          color: Colors.black26,
          child: Form(
            child: buildInput(),
          )

      ),
    );

  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
  Widget buildInput() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey[900],
              margin: EdgeInsets.symmetric(vertical: 35.0, horizontal: 0.0),
              child: Column(
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SuperIcon(
                          iconPath: cate.iconID,
                          size: 49.0,
                        ),
                        onPressed: () async {
                          var data = await showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => IconPicker(),
                          );
                          if (data != null) {
                            setState(() {
                              cate.iconID = data;
                            });
                          }
                        },
                        iconSize: 70,
                        color: Color(0xff8f8f8f),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 50),
                          width: 250,
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 1),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white60, width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white60, width: 3),
                              ),
                              labelText: 'Name event',
                              labelStyle: TextStyle(
                                  color: Colors.white60, fontSize: 15),
                            ),
                            onChanged: (value) => nameEvent = value,
                            validator: (value) {
                              if (value == null || value.length == 0)
                                return 'Name is empty';
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Colors.white,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    dense: true,
                    leading:
                    Icon(Icons.calendar_today, color: Colors.white54, size: 28.0),
                    title: TextFormField(
                      onTap: () async {
                        DatePicker.showDatePicker(context,
                            currentTime: endDate == null
                                ? DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day)
                                : endDate,
                            showTitleActions: true, onConfirm: (date) {
                              if (date != null) {
                                setState(() {
                                  endDate = date;
                                });
                              }
                            },
                            locale: LocaleType.en,
                            theme: DatePickerTheme(
                              cancelStyle: TextStyle(color: Colors.white),
                              doneStyle: TextStyle(color: Colors.white),
                              itemStyle: TextStyle(color: Colors.white),
                              backgroundColor: Colors.grey[900],
                            ));
                      },
                      readOnly: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                            color: endDate == null ? Colors.grey[600] : Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight:
                            endDate == null ? FontWeight.w500 : FontWeight.w600,
                          ),
                          hintText: endDate ==
                              DateTime.parse(
                                  DateFormat("yyyy-MM-dd").format(DateTime.now()))
                              ? 'Today'
                              : endDate ==
                              DateTime.parse(DateFormat("yyyy-MM-dd").format(
                                  DateTime.now().add(Duration(days: 1))))
                              ? 'Tomorrow'
                              : endDate ==
                              DateTime.parse(DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now()
                                  .subtract(Duration(days: 1))))
                              ? 'Yesterday'
                              : DateFormat('EEEE, dd-MM-yyyy')
                              .format(endDate)),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.white54),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                    child: Divider(
                      color: Colors.white24,
                      height: 1,
                      thickness: 0.2,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    onTap: () {
                      showCurrencyPicker(
                        theme: CurrencyPickerThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                          ),
                          flagSize: 26,
                          titleTextStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          subtitleTextStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              color: Colors.black),
                          //backgroundColor: Colors.grey[900],
                        ),
                        onSelect: (value) {
                          currencySymbol = value.code;
                          setState(() {
                            currencySymbol = value.name;
                          });
                        },
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.monetization_on,
                        size: 30.0, color: Colors.white24),
                    title: Text(currencySymbol,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right,
                        size: 20.0, color: Colors.white),
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Colors.white,
                  ),
                  ListTile(
                    dense: true,
                    onTap: () async {
                      var res = await showCupertinoModalBottomSheet(
                          isDismissible: true,
                          backgroundColor: Colors.grey[900],
                          context: context,
                          builder: (context) =>
                              SelectWalletAccountScreen(wallet: selectedWallet));
                      if (res != null)
                        setState(() {
                          selectedWallet = res;
                        });
                    },
                    leading: selectedWallet == null
                        ? SuperIcon(iconPath: 'assets/icons/wallet_2.svg', size: 28.0)
                        : SuperIcon(iconPath: selectedWallet.iconID, size: 28.0),
                    title: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                            color: selectedWallet == null
                                ? Colors.grey[600]
                                : Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: selectedWallet == null
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                          hintText: selectedWallet == null
                              ? 'Select wallet'
                              : selectedWallet.name),
                      onTap: () async {
                        var res = await showCupertinoModalBottomSheet(
                            isDismissible: true,
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) =>
                                SelectWalletAccountScreen(wallet: selectedWallet));
                        if (res != null)
                          setState(() {
                            selectedWallet = res;
                          });
                      },
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
