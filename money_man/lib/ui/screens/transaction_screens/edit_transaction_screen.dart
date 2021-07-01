import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  // biến thời gian của transaction
  DateTime pickDate;
  // biến ký hiệu tiền tệ của transaction
  String currencySymbol;
  // biến số tiền của transaction
  double amount;
  // biến ký hiệu của transaction
  String note;
  // biến contact của transaction
  String contact;
  // biến event của transaction
  Event event;
  // biến xác định user có pick event hay không
  bool pickEvent;
  // biến xác định transaction có phải là debt/loan
  bool isDebtLoan;

  @override
  void initState() {
    super.initState();
    pickDate = widget.transaction.date;
    currencySymbol =
        CurrencyService().findByCode(widget.wallet.currencyID).symbol;
    amount = widget.transaction.amount;
    note = widget.transaction.note;
    contact = widget.transaction.contact;
    event = widget.event;
    isDebtLoan = widget.transaction.category.type == 'debt & loan';
    pickEvent = false;
  }

  @override
  Widget build(BuildContext context) {
    // biến thao tác với database
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.appBarColor,
        title: Text('Edit Transaction',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,
            )),
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // nếu transaction không thay đổi thì return
              if (amount == widget.transaction.amount &&
                  widget.transaction.date.compareTo(pickDate) == 0 &&
                  note == widget.transaction.note &&
                  contact == widget.transaction.contact &&
                  ((event == null && widget.transaction.eventID == '') ||
                      (event != null &&
                          widget.transaction.eventID == event.id))) return;
              // low down bàn phím
              FocusScope.of(context).requestFocus(FocusNode());

              MyTransaction transaction = MyTransaction(
                id: widget.transaction.id,
                amount: amount,
                date: pickDate,
                currencyID: widget.transaction.currencyID,
                category: widget.transaction.category,
                note: note,
                contact: contact,
                eventID: event == null ? '' : event.id,
                // xác định extraAmount
                extraAmountInfo: widget.transaction.extraAmountInfo == null
                    ? null
                    : amount -
                        (widget.transaction.amount -
                            widget.transaction.extraAmountInfo),
              );

              // nếu transaction có cate là repayment hay debt collection
              if (transaction.category.name == 'Repayment' ||
                  transaction.category.name == 'Debt Collection') {
                // update các thông tin cần thiết của transaction sau khi edit
                var res = await _firestore.updateDebtLoanTransationAfterEdit(
                    widget.transaction, transaction, widget.wallet);
                if (res == null) {
                  await showAlertDialog(
                      'The amount must be less than or equal to unpaid amount');
                  return;
                }
              }

              // nếu transaction có cate là Debt hay Loan
              if (transaction.category.name == 'Debt' ||
                  transaction.category.name == 'Loan') {
                if (transaction.amount <
                    (widget.transaction.amount -
                        widget.transaction.extraAmountInfo)) {
                  await showAlertDialog(
                      'Transaction amount must be less than or equal to paid amount');
                  return;
                }
              }

              await _firestore.updateTransaction(transaction, widget.wallet);
              Navigator.pop(context, transaction);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: (amount == widget.transaction.amount &&
                        widget.transaction.date.compareTo(pickDate) == 0 &&
                        note == widget.transaction.note &&
                        contact == widget.transaction.contact &&
                        ((event == null && widget.transaction.eventID == '') ||
                            (event != null &&
                                widget.transaction.eventID == event.id)))
                    ? Style.foregroundColor.withOpacity(0.24)
                    : Style.foregroundColor,
                fontFamily: Style.fontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
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
                    amount = double.parse(resultAmount);
                  });
              },
              leading: SuperIcon(
                iconPath: 'assets/images/coin.svg',
                size: 35,
              ),
              title: TextFormField(
                readOnly: true,
                onTap: () async {
                  final resultAmount =
                      await await showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => EnterAmountScreen());
                  if (resultAmount != null)
                    setState(() {
                      amount = double.parse(resultAmount);
                    });
                },
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
                      color: amount == null
                          ? Style.foregroundColor.withOpacity(0.24)
                          : Style.foregroundColor,
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
              trailing: Icon(Icons.lock,
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
              onTap: () {},
              leading: SuperIcon(
                iconPath: widget.wallet.iconID,
                size: 28.0,
              ),
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
              trailing: Icon(Icons.lock,
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
              onTap: () async {
                DatePicker.showDatePicker(context,
                    currentTime: pickDate,
                    showTitleActions: true, onConfirm: (date) {
                  if (date != null) {
                    setState(() {
                      pickDate = date;
                      // load lại event nếu thời gian được chọn quá mức cho phép của event
                      if (event != null) {
                        if (pickDate.year > event.endDate.year ||
                            (pickDate.year == event.endDate.year &&
                                pickDate.month > event.endDate.month) ||
                            (pickDate.year == event.endDate.year &&
                                pickDate.month == event.endDate.month &&
                                pickDate.day > event.endDate.day)) event = null;
                      }
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
              dense: true,
              leading:
                  SuperIcon(iconPath: 'assets/images/time.svg', size: 28.0),
              title: TextFormField(
                onTap: () async {
                  DatePicker.showDatePicker(context,
                      currentTime: pickDate,
                      showTitleActions: true, onConfirm: (date) {
                    if (date != null) {
                      setState(() {
                        pickDate = date;
                        // load lại event nếu thời gian được chọn quá mức cho phép của event
                        if (event != null) {
                          if (pickDate.year > event.endDate.year ||
                              (pickDate.year == event.endDate.year &&
                                  pickDate.month > event.endDate.month) ||
                              (pickDate.year == event.endDate.year &&
                                  pickDate.month == event.endDate.month &&
                                  pickDate.day > event.endDate.day))
                            event = null;
                        }
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
                      color: pickDate == null
                          ? Style.foregroundColor.withOpacity(0.24)
                          : Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight:
                          pickDate == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    // xử lý hint text
                    // nếu thời gian được chọn là hôm nay thì hiện today
                    // ngày mai là tomorrow
                    // ngày hôm qua là yesterday
                    // còn các ngày khác thì theo form (thứ, ngày/tháng/năm)
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
              leading: Container(
                  padding: EdgeInsets.only(left: 4),
                  child:
                      SuperIcon(iconPath: 'assets/images/note.svg', size: 21)),
              title: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: note == '' || note == null
                            ? Style.foregroundColor.withOpacity(0.24)
                            : Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: note == '' || note == null
                            ? FontWeight.w500
                            : FontWeight.w600),
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
                      builder: (context) => NoteScreen(
                            content: note,
                          ));
                  if (noteContent != null) {
                    setState(() {
                      note = noteContent;
                    });
                  }
                },
              ),
              trailing: Icon(Icons.chevron_right,
                  color: Style.foregroundColor.withOpacity(0.54)),
            ),
            Column(
              children: <Widget>[
                Visibility(
                  visible: !pickEvent,
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
                if (isDebtLoan == true)
                  Column(
                    children: [
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
                          minLeadingWidth: 42,
                          dense: true,
                          leading: SuperIcon(
                            iconPath: 'assets/images/account_screen/user2.svg',
                            size: 28,
                          ),
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
                                    color:
                                        Style.foregroundColor.withOpacity(0.24),
                                    fontFamily: Style.fontFamily,
                                    fontSize: 16.0,
                                    fontWeight: contact == null
                                        ? FontWeight.w500
                                        : FontWeight.w600),
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
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                      ),
                    ],
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
                      minLeadingWidth: 42,
                      dense: true,
                      onTap: () async {
                        var res = await showCupertinoModalBottomSheet(
                            isDismissible: true,
                            backgroundColor: Style.boxBackgroundColor,
                            context: context,
                            builder: (context) => SelectEventScreen(
                                  wallet: widget.wallet,
                                  timeTransaction: pickDate,
                                ));
                        if (res != null)
                          setState(() {
                            event = res;
                          });
                      },
                      leading: event == null
                          ? SuperIcon(
                              iconPath: 'assets/images/event.svg', size: 28)
                          : SuperIcon(iconPath: event.iconPath, size: 28.0),
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
                              color: event == null
                                  ? Style.foregroundColor.withOpacity(0.24)
                                  : Style.foregroundColor,
                              fontFamily: Style.fontFamily,
                              fontSize: 16.0,
                              fontWeight: event == null
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                            hintText:
                                event == null ? 'Select event' : event.name),
                        onTap: () async {
                          var res = await showCupertinoModalBottomSheet(
                              isDismissible: true,
                              backgroundColor: Style.boxBackgroundColor,
                              context: context,
                              builder: (context) => SelectEventScreen(
                                    wallet: widget.wallet,
                                    timeTransaction: pickDate,
                                  ));
                          if (res != null)
                            setState(() {
                              event = res;
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

  Future<void> showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
