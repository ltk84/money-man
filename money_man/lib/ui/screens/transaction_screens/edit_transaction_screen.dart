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
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
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
  bool isDebtLoan;

  @override
  void initState() {
    super.initState();
    pickDate = widget.transaction.date;
    currencySymbol =
        CurrencyService()
            .findByCode(widget.wallet.currencyID)
            .symbol;
    amount = widget.transaction.amount;
    note = widget.transaction.note;
    contact = widget.transaction.contact;
    _event = widget.event;
    isDebtLoan = widget.transaction.category.type == 'debt & loan';
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor,
        title: Text('Edit Transaction',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,)),
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (
              amount == widget.transaction.amount
                  && widget.transaction.date.compareTo(pickDate) == 0
                  && note == widget.transaction.note
                  && contact == widget.transaction.contact
                  && ((_event == null && widget.transaction.eventID == '')
                  ||
                  (_event != null && widget.transaction.eventID == _event.id))
              )
                return;
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
                extraAmountInfo: widget.transaction.extraAmountInfo == null
                    ? null
                    : amount -
                    (widget.transaction.amount -
                        widget.transaction.extraAmountInfo),
              );

              if (_transaction.category.name == 'Repayment' ||
                  _transaction.category.name == 'Debt Collection') {
                var res = await _firestore.updateDebtLoanTransationAfterEdit(
                    widget.transaction, _transaction, widget.wallet);
                if (res == null) {
                  await _showAlertDialog(
                      'The amount must be less than or equal to unpaid amount');
                  return;
                }
              }

              if (_transaction.category.name == 'Debt' ||
                  _transaction.category.name == 'Loan') {
                // print(_transaction);
                if (_transaction.amount <
                    (widget.transaction.amount -
                        widget.transaction.extraAmountInfo)) {
                  await _showAlertDialog(
                      'Transaction amount must be less than or equal to paid amount');
                  return;
                }
              }

              await _firestore.updateTransaction(_transaction, widget.wallet);
              Navigator.pop(context, _transaction);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color:
                (
                    amount == widget.transaction.amount
                        && widget.transaction.date.compareTo(pickDate) == 0
                        && note == widget.transaction.note
                        && contact == widget.transaction.contact
                        && ((_event == null && widget.transaction.eventID == '')
                        || (_event != null &&
                            widget.transaction.eventID == _event.id))
                )
                    ? Style.foregroundColor.withOpacity(0.24)
                    : Style.foregroundColor,
                fontFamily: Style.fontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),)
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
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
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              minVerticalPadding: 10.0,
              onTap: () async {
                final resultAmount = await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => EnterAmountScreen());
                if (resultAmount != null)
                  setState(() {
                    print(resultAmount);
                    amount = double.parse(resultAmount);
                  });
              },
              leading: Icon(Icons.money_rounded,
                  color: Style.foregroundColor.withOpacity(0.54), size: 45.0),
              title: TextFormField(
                readOnly: true,
                onTap: () async {
                  final resultAmount = await await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => EnterAmountScreen());
                  if (resultAmount != null)
                    setState(() {
                      amount = double.parse(resultAmount);
                    });
                },
                // onChanged: (value) => amount = double.tryParse(value),
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontSize: 30.0,
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: amount == null ? Style.foregroundColor.withOpacity(
                          0.24) : Style.foregroundColor,
                      fontSize: amount == null ? 22 : 30.0,
                      fontFamily: Style.fontFamily,
                      fontWeight:
                      amount == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: amount == null
                        ? 'Enter amount'
                        : MoneySymbolFormatter(
                        text: amount,
                        currencyId: widget.wallet.currencyID)
                        .formatText),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
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
                    color: Style.foregroundColor,
                    fontSize: 16.0,
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: widget.transaction.category.name == null
                            ? Style.foregroundColor.withOpacity(0.24)
                            : Style.foregroundColor,
                        fontSize: 16.0,
                        fontFamily: Style.fontFamily,
                        fontWeight: widget.transaction.category.name == null
                            ? FontWeight.w500
                            : FontWeight.w600),
                    hintText: widget.transaction.category.name == null
                        ? 'Select category'
                        : widget.transaction.category.name),
              ),
              trailing: Icon(
                  Icons.lock, color: Style.foregroundColor.withOpacity(0.54)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
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
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
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
                          ? Style.foregroundColor.withOpacity(0.24)
                          : Style.foregroundColor,
                      fontFamily: Style.fontFamily,
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
              trailing: Icon(
                  Icons.lock, color: Style.foregroundColor.withOpacity(0.54)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
                height: 1,
                thickness: 0.2,
              ),
            ),
            ListTile(
              dense: true,
              leading:
              Icon(Icons.calendar_today,
                  color: Style.foregroundColor.withOpacity(0.54), size: 28.0),
              title: TextFormField(
                onTap: () async {
                  DatePicker.showDatePicker(context,
                      currentTime: pickDate,
                      showTitleActions: true,
                      onConfirm: (date) {
                        if (date != null) {
                          setState(() {
                            pickDate = date;
                          });
                        }
                      },
                      locale: LocaleType.en,
                      theme: DatePickerTheme(
                        cancelStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor
                        ),
                        doneStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor
                        ),
                        itemStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor
                        ),
                        backgroundColor: Style.boxBackgroundColor,
                      ));
                },
                readOnly: true,
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: pickDate == null ? Style.foregroundColor
                          .withOpacity(0.24) : Style.foregroundColor,
                      fontFamily: Style.fontFamily,
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
              trailing: Icon(Icons.chevron_right,
                  color: Style.foregroundColor.withOpacity(0.54)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
                height: 1,
                thickness: 0.2,
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(
                  Icons.note, color: Style.foregroundColor.withOpacity(0.54),
                  size: 28.0),
              title: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: note == '' || note == null ? Style
                            .foregroundColor.withOpacity(0.24) : Style
                            .foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: note == '' || note == null
                            ? FontWeight.w500
                            : FontWeight.w600
                    ),
                    hintText: note == '' || note == null ? 'Write note' : note),
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
                onTap: () async {
                  final noteContent = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.boxBackgroundColor,
                      context: context,
                      builder: (context) =>
                          NoteScreen(
                            content: note,
                          ));
                  print(noteContent);
                  if (noteContent != null) {
                    setState(() {
                      note = noteContent;
                      print(note);
                    });
                  }
                },
              ),
              trailing: Icon(Icons.chevron_right,
                  color: Style.foregroundColor.withOpacity(0.54)),
            ),
            (_event != null)
                ? Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Divider(
                    color: Style.foregroundColor.withOpacity(0.24),
                    height: 1,
                    thickness: 0.2,
                  ),
                ),
                ListTile(
                  dense: true,
                  onTap: () async {
                    var res = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.boxBackgroundColor,
                        context: context,
                        builder: (context) =>
                            SelectEventScreen(wallet: widget.wallet));
                    if (res != null)
                      setState(() {
                        _event = res;
                      });
                  },
                  leading: _event == null
                      ? Icon(
                    Icons.event,
                    size: 28.0,
                    color: Style.foregroundColor.withOpacity(0.54),
                  )
                      : SuperIcon(iconPath: _event.iconPath, size: 28.0),
                  title: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
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
                              ? Style.foregroundColor.withOpacity(0.24)
                              : Style.foregroundColor,
                          fontFamily: Style.fontFamily,
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
                          backgroundColor: Style.boxBackgroundColor,
                          context: context,
                          builder: (context) =>
                              SelectEventScreen(wallet: widget.wallet));
                      if (res != null)
                        setState(() {
                          _event = res;
                        });
                    },
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: Style.foregroundColor.withOpacity(0.54)),
                ),
              ],
            )
                : Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Divider(
                    color: Style.foregroundColor.withOpacity(0.24),
                    height: 1,
                    thickness: 0.2,
                  ),
                ),
                Visibility(
                  visible: !pickEvent,
                  child: Container(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          pickEvent = true;
                        });
                      },
                      child: Text(
                        'More',
                        style: TextStyle(
                          color: Style.primaryColor,
                          fontFamily: Style.fontFamily,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isDebtLoan == false)
                  Visibility(
                    visible: pickEvent,
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.person,
                          color: Style.foregroundColor.withOpacity(0.54),
                          size: 28.0),
                      title: TextFormField(
                        onTap: () async {
                          final PhoneContact phoneContact =
                          await FlutterContactPicker.pickPhoneContact();
                          if (phoneContact != null)
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
                                color: Style.foregroundColor.withOpacity(0.24),
                                fontFamily: Style.fontFamily,
                                fontSize: 16.0,
                                fontWeight: contact == null
                                    ? FontWeight.w500
                                    : FontWeight.w600
                            ),
                            hintText: contact == null
                                ? widget.transaction.category.name == 'Debt'
                                ? 'Lender'
                                : widget.transaction.category.name ==
                                'Loan'
                                ? 'Borrower'
                                : 'With'
                                : contact),
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing:
                      Icon(Icons.chevron_right,
                          color: Style.foregroundColor.withOpacity(0.54)),
                    ),
                  ),
                Visibility(
                  visible: pickEvent,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                    child: Divider(
                      color: Style.foregroundColor.withOpacity(0.24),
                      height: 1,
                      thickness: 0.2,
                    ),
                  ),
                ),
                Visibility(
                    visible: pickEvent,
                    child: ListTile(
                      dense: true,
                      onTap: () async {
                        var res = await showCupertinoModalBottomSheet(
                            isDismissible: true,
                            backgroundColor: Style.boxBackgroundColor,
                            context: context,
                            builder: (context) =>
                                SelectEventScreen(wallet: widget.wallet));
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
                        color: Style.foregroundColor.withOpacity(0.54),
                      )
                          : SuperIcon(
                          iconPath: _event.iconPath, size: 28.0),
                      title: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontFamily: Style.fontFamily,
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
                                  ? Style.foregroundColor.withOpacity(0.24)
                                  : Style.foregroundColor,
                              fontFamily: Style.fontFamily,
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
                              backgroundColor: Style.boxBackgroundColor,
                              context: context,
                              builder: (context) =>
                                  SelectEventScreen(
                                      wallet: widget.wallet));
                          if (res != null)
                            setState(() {
                              _event = res;
                              // widget.transaction.eventID = _event.id;
                            });
                        },
                      ),
                      trailing: Icon(Icons.chevron_right,
                          color: Style.foregroundColor.withOpacity(0.54)),
                    ))
              ],
            )
          ],
        ),
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
}
