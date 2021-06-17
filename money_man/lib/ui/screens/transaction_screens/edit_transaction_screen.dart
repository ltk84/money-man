import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/selection_event.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/shared_screens/note_srcreen.dart';
import 'package:provider/provider.dart';

class EditTransactionScreen extends StatefulWidget {
  MyTransaction transaction;
  Wallet wallet;
  Event event;
  EditTransactionScreen({
    Key key,
    @required this.wallet,
    @required this.transaction,
    @required this.event,
  }) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  DateTime pickDate;
  DateTime formatTransDate;
  String currencySymbol;
  double amount;
  String note;
  String contact;
  Event _event;
  bool pickEvent = false;

  @override
  void initState() {
    super.initState();
    pickDate = widget.transaction.date;
    currencySymbol =
        CurrencyService().findByCode(widget.wallet.currencyID).symbol;
    amount = widget.transaction.amount;
    note = widget.transaction.note;
    contact = widget.transaction.contact;
    _event = widget.event;
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
        title: Text('Edit Transaction',
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
                FocusScope.of(context).requestFocus(FocusNode());
                MyTransaction _transaction = MyTransaction(
                  id: widget.transaction.id,
                  amount: amount,
                  date: pickDate,
                  currencyID: widget.transaction.currencyID,
                  category: widget.transaction.category,
                  note: note,
                  contact: contact,
                  eventID: _event == null ? '' : _event.id,
                );

                await _firestore.updateTransaction(_transaction, widget.wallet);
                Navigator.pop(context, _transaction);
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
              ))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
        decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(
                top: BorderSide(
                  color: Colors.white12,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.white12,
                  width: 0.5,
                ))),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              minVerticalPadding: 10.0,
              onTap: () async {
                final resultAmount = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                if (resultAmount != null)
                  setState(() {
                    print(resultAmount);
                    amount = double.parse(resultAmount);
                  });
              },
              leading: Icon(Icons.money, color: Colors.white54, size: 45.0),
              title: TextFormField(
                readOnly: true,
                onTap: () async {
                  final resultAmount = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                  if (resultAmount != null)
                    setState(() {
                      amount = double.parse(resultAmount);
                    });
                },
                // onChanged: (value) => amount = double.tryParse(value),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: amount == null ? Colors.grey[600] : Colors.white,
                      fontSize: amount == null ? 22 : 30.0,
                      fontFamily: 'Montserrat',
                      fontWeight:
                          amount == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: amount == null
                        ? 'Enter amount'
                        : currencySymbol +
                            ' ' +
                            MoneyFormatter(amount: amount)
                                .output
                                .withoutFractionDigits),
              ),
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
              dense: true,
              onTap: () {},
              leading: SuperIcon(
                  iconPath: widget.transaction.category.iconID, size: 28.0),
              title: TextField(
                onTap: () {},
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: widget.transaction.category.name == null
                            ? Colors.grey[600]
                            : Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Montserrat',
                        fontWeight: widget.transaction.category.name == null
                            ? FontWeight.w500
                            : FontWeight.w600),
                    hintText: widget.transaction.category.name == null
                        ? 'Select category'
                        : widget.transaction.category.name),
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
              dense: true,
              leading:
                  Icon(Icons.calendar_today, color: Colors.white54, size: 28.0),
              title: TextFormField(
                onTap: () async {
                  DatePicker.showDatePicker(context,
                      currentTime: pickDate,
                      showTitleActions: true, onConfirm: (date) {
                    if (date != null) {
                      setState(() {
                        pickDate = date;
                        if(_event != null)
                        {
                          if(pickDate.year > _event.endDate.year ||
                              (pickDate.year == _event.endDate.year && pickDate.month > _event.endDate.month)||
                              (pickDate.year == _event.endDate.year && pickDate.month == _event.endDate.month && pickDate.day > _event.endDate.day))
                            _event = null;
                        }
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
                      color: pickDate == null ? Colors.grey[600] : Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight:
                          pickDate == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: pickDate == null
                        ? 'Select date'
                        : pickDate ==
                                DateTime.parse(DateFormat("yyyy-MM-dd")
                                    .format(DateTime.now()))
                            ? 'Today'
                            : pickDate ==
                                    DateTime.parse(DateFormat("yyyy-MM-dd")
                                        .format(DateTime.now()
                                            .add(Duration(days: 1))))
                                ? 'Tomorrow'
                                : pickDate ==
                                        DateTime.parse(DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now()
                                                .subtract(Duration(days: 1))))
                                    ? 'Yesterday'
                                    : DateFormat('EEEE, dd-MM-yyyy')
                                        .format(pickDate)),
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
              dense: true,
              onTap: () {},
              leading: SuperIcon(
                iconPath: widget.wallet.iconID,
                size: 28.0,
              ),
              // leading: Icon(Icons.wallet_giftcard),
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
                      color: widget.wallet == null
                          ? Colors.grey[600]
                          : Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: widget.wallet == null
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                    hintText: widget.wallet == null
                        ? 'Select wallet'
                        : widget.wallet.name),
                onTap: () {},
              ),
              trailing: Icon(Icons.lock, color: Colors.white54),
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
              dense: true,
              leading: Icon(Icons.note, color: Colors.white54, size: 28.0),
              title: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                    hintText: note == '' || note == null ? 'Write note' : note),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
                onTap: () async {
                  final noteContent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NoteScreen(
                                content: note,
                              )));
                  print(noteContent);
                  if (noteContent != null) {
                    setState(() {
                      note = noteContent;
                      print(note);
                    });
                  }
                },
              ),
            ),
            (_event != null)
                ? ListTile(
                    dense: true,
                    onTap: () async {
                      var res = await showCupertinoModalBottomSheet(
                          isDismissible: true,
                          backgroundColor: Colors.grey[900],
                          context: context,
                          builder: (context) =>
                              SelectEventScreen(
                                  wallet: widget.wallet,
                                timeTransaction: pickDate,
                              ));
                      if (res != null)
                        setState(() {
                          _event = res;
                        });
                    },
                    leading: _event == null
                        ? Icon(
                            Icons.event,
                            size: 28.0,
                            color: Colors.white54,
                          )
                        : SuperIcon(iconPath: _event.iconPath, size: 28.0),
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
                            color: _event == null
                                ? Colors.grey[600]
                                : Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: _event == null
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                          hintText:
                              _event == null ? 'Select event' : _event.name),
                      onTap: () async {
                        var res = await showCupertinoModalBottomSheet(
                            isDismissible: true,
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) =>
                                SelectEventScreen(
                                    wallet: widget.wallet,
                                  timeTransaction: pickDate,
                                ));
                        if (res != null)
                          setState(() {
                            _event = res;
                          });
                      },
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.white54),
                  )
                : Column(
                    children: <Widget>[
                      Visibility(
                        visible: !pickEvent,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              pickEvent = true;
                            });
                          },
                          child: Text(
                            'More',
                            style: TextStyle(color: Color(0xff36D1B5)),
                          ),
                          style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                      ),
                      Visibility(
                        visible: !pickEvent,
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.account_balance_outlined,
                              color: Colors.white54, size: 28.0),
                          title: TextFormField(
                            onTap: () async {
                              final PhoneContact phoneContact =
                                  await FlutterContactPicker.pickPhoneContact();
                              print(phoneContact.fullName);
                              setState(() {
                                contact = phoneContact.fullName;
                              });
                            },
                            readOnly: true,
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                                hintText: contact == null
                                    ? widget.transaction.category.name == 'Debt'
                                        ? 'Lender'
                                        : widget.transaction.category.name ==
                                                'Loan'
                                            ? 'Borrower'
                                            : 'With'
                                    : contact),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing:
                              Icon(Icons.chevron_right, color: Colors.white54),
                        ),
                      ),
                      Visibility(
                          visible: pickEvent,
                          child: ListTile(
                            dense: true,
                            onTap: () async {
                              var res = await showCupertinoModalBottomSheet(
                                  isDismissible: true,
                                  backgroundColor: Colors.grey[900],
                                  context: context,
                                  builder: (context) =>
                                      SelectEventScreen(
                                          wallet: widget.wallet,
                                        timeTransaction: pickDate,
                                      ));
                              if (res != null)
                                setState(() {
                                  _event = res;
                                  // widget.transaction.eventID = _event.id;
                                });
                            },
                            leading: _event == null
                                ? Icon(
                                    Icons.event,
                                    size: 28.0,
                                    color: Colors.white54,
                                  )
                                : SuperIcon(
                                    iconPath: _event.iconPath, size: 28.0),
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
                                    color: _event == null
                                        ? Colors.grey[600]
                                        : Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.0,
                                    fontWeight: _event == null
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                  ),
                                  hintText: _event == null
                                      ? 'Select event'
                                      : _event.name),
                              onTap: () async {
                                var res = await showCupertinoModalBottomSheet(
                                    isDismissible: true,
                                    backgroundColor: Colors.grey[900],
                                    context: context,
                                    builder: (context) => SelectEventScreen(
                                        wallet: widget.wallet,
                                      timeTransaction: pickDate,
                                    ));
                                if (res != null)
                                  setState(() {
                                    _event = res;
                                    // widget.transaction.eventID = _event.id;
                                  });
                              },
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: Colors.white54),
                          ))
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
