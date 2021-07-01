import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/date_format.dart';

class EditEventScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  EditEventScreen({Key key, this.currentEvent, this.eventWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditEventScreen();
  }
}

class _EditEventScreen extends State<EditEventScreen>
    with TickerProviderStateMixin {
  Event _currentEvent;
  Wallet _eventWallet;
  DateTime endDate;

  String iconPath;

  String currencySymbol = 'Viet Nam Dong';

  String nameEvent;
  DateTime formatTransDate;
  bool CompareDate(DateTime a, DateTime b) {
    if (a.year < b.year) return true;
    if (a.year == b.year && a.month < b.month) return true;
    if (a.year == b.year && a.month == b.month && a.day < b.day) return true;
    return false;
  }

  @override
  void initState() {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    endDate = _currentEvent.endDate;
    iconPath = _currentEvent.iconPath;
    currencySymbol = _eventWallet.currencyID;
    nameEvent = _currentEvent.name;
    formatTransDate = DateTime(widget.currentEvent.endDate.year,
        widget.currentEvent.endDate.month, widget.currentEvent.endDate.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Style.appBarColor,
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        title: Text(
          'Edit event',
          style: TextStyle(
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            color: Style.foregroundColor,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (_currentEvent == null) {
                  _showAlertDialog('Please pick your wallet!');
                } else if (nameEvent == null) {
                  _showAlertDialog('Please enter name!');
                } else if (iconPath == null) {
                  _showAlertDialog('Please pick category');
                } else if (CompareDate(endDate, DateTime.now())) {
                  _showAlertDialog(
                      'Please select an end date greater than or equal to today ');
                } else {
                  _currentEvent.name = nameEvent;
                  _currentEvent.endDate = endDate;
                  _currentEvent.iconPath = iconPath;
                  _currentEvent.isFinished =
                      (endDate.year < DateTime.now().year)
                          ? true
                          : (endDate.month < DateTime.now().month)
                              ? true
                              : (endDate.day < DateTime.now().day)
                                  ? true
                                  : false;
                  _currentEvent.walletId = _currentEvent.id;
                  await _firestore.updateEvent(_currentEvent, _eventWallet);
                  Navigator.pop(context);
                }
              },
              child: Text('Save',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                  )),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              ))
        ],
      ),
      body: Container(
          color: Style.backgroundColor1,
          child: Form(
            child: buildInput(),
          )),
    );
  }

  Widget buildInput() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30.0),
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
          child: Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                    icon: SuperIcon(
                      iconPath: iconPath,
                      size: 40.0,
                    ),
                    onPressed: () async {
                      var data = await showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => IconPicker(),
                      );
                      if (data != null) {
                        setState(() {
                          iconPath = data;
                        });
                      }
                    },
                    iconSize: 50,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 35.0,
                    ),
                    onPressed: () async {
                      var data = await showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => IconPicker(),
                      );
                      if (data != null) {
                        setState(() {
                          iconPath = data;
                        });
                      }
                    },
                    iconSize: 20,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 50),
                      width: 250,
                      child: TextFormField(
                        initialValue: _currentEvent.name,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: Style.fontFamily,
                          fontSize: 20,
                          color: Style.foregroundColor,
                          decoration: TextDecoration.none,
                        ),
                        decoration: InputDecoration(
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.6),
                                width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.6),
                                width: 3),
                          ),
                          labelText: 'Name event',
                          labelStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              color: Style.foregroundColor.withOpacity(0.6),
                              fontSize: 15),
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
              Container(
                margin: EdgeInsets.only(left: 70, top: 10),
                child: Divider(
                  color: Style.foregroundColor.withOpacity(0.12),
                  thickness: 0.5,
                ),
              ),
              ListTile(
                dense: true,
                leading: SuperIcon(
                  iconPath: 'assets/images/time.svg',
                  size: 30,
                ),
                title: TextFormField(
                  onTap: () async {
                    DatePicker.showDatePicker(context,
                        currentTime:
                            endDate == null ? formatTransDate : endDate,
                        showTitleActions: true, onConfirm: (date) {
                      if (date != null) {
                        setState(() {
                          endDate = date;
                          _currentEvent.endDate = endDate;
                        });
                      }
                    },
                        locale: LocaleType.en,
                        theme: DatePickerTheme(
                          cancelStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Style.foregroundColor),
                          doneStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Style.foregroundColor),
                          itemStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Style.foregroundColor),
                          backgroundColor: Style.boxBackgroundColor,
                        ));
                  },
                  readOnly: true,
                  style: TextStyle(
                      color: Style.foregroundColor,
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
                      color: _currentEvent.endDate == null
                          ? Style.foregroundColor.withOpacity(0.6)
                          : Style.foregroundColor,
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: _currentEvent.endDate == null
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                    hintText: DateFormat('EEEE, dd-MM-yyyy')
                        .format(_currentEvent.endDate),
                  ),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Style.foregroundColor.withOpacity(0.6)),
              ),
              Container(
                margin: EdgeInsets.only(left: 70),
                child: Divider(
                  color: Style.foregroundColor.withOpacity(0.12),
                  thickness: 0.5,
                ),
              ),
              ListTile(
                onTap: () {},
                dense: true,
                leading: SuperIcon(
                  iconPath: 'assets/images/coin.svg',
                  size: 28,
                ),
                title: Text(currencySymbol,
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0)),
                trailing: Icon(Icons.lock,
                    color: Style.foregroundColor.withOpacity(0.6)),
              ),
              Container(
                margin: EdgeInsets.only(left: 70),
                child: Divider(
                  color: Style.foregroundColor.withOpacity(0.12),
                  thickness: 0.5,
                ),
              ),
              ListTile(
                dense: true,
                onTap: () async {
                  var res = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.backgroundColor,
                      context: context,
                      builder: (context) =>
                          SelectWalletScreen(currentWallet: _eventWallet));
                  if (res != null)
                    setState(() {
                      _eventWallet = res;
                    });
                },
                leading: _eventWallet == null
                    ? SuperIcon(
                        iconPath: 'assets/icons/wallet_2.svg', size: 28.0)
                    : SuperIcon(iconPath: _eventWallet.iconID, size: 28.0),
                title: TextFormField(
                  initialValue: _eventWallet.name,
                  readOnly: true,
                  style: TextStyle(
                      color: Style.foregroundColor,
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
                        color: _eventWallet == null
                            ? Style.foregroundColor.withOpacity(0.6)
                            : Style.foregroundColor,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: _eventWallet == null
                            ? FontWeight.w500
                            : FontWeight.w600,
                      ),
                      hintText: _eventWallet == null
                          ? 'Select wallet'
                          : _eventWallet.name),
                  onTap: () async {},
                ),
                trailing: Icon(Icons.lock,
                    color: Style.foregroundColor.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.6),
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
