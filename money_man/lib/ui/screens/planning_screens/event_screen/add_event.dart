import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/category_model.dart';
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

// Màn hình add event được mở ra khi ấn vào dấu + ở event home
class AddEvent extends StatefulWidget {
  Wallet wallet; // Ví hiện tại
  AddEvent({Key key, this.wallet}) : super(key: key);
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime endDate; // ngày kết thúc
// Category cho event
  MyCategory cate;
// Ví của event
  Wallet selectedWallet;
// Đơn vị tiền tệ cho event
  String currencySymbol = '';
// Tên của event
  String nameEvent;
// Lưu trữ danh sách id của các transaction
  List<String> transactionIdList = [];
  @override
  void initState() {
    // Chọn ví mặc định là ví được truyền vào
    selectedWallet = widget.wallet;
    // Cho đơn vị tiền tệ là đơn vị tiền tệ của ví được thêm vào
    currencySymbol = selectedWallet.currencyID;
    // Ngày kết thúc
    endDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    // Khởi tạo giá trị mặc định cho category
    cate = MyCategory(
      id: '0',
      name: 'name',
      type: 'type',
      iconID: 'assets/icons/travel.svg',
    );
    super.initState();
  }

// So sánh 2 ngày
  bool checkAisBeforeB(DateTime a, DateTime b) {
    if (a.year < b.year) return true;
    if (a.year == b.year && a.month < b.month) return true;
    if (a.year == b.year && a.month == b.month && a.day < b.day) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // tham chiếu tới các hàm của firestore
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.appBarColor,
        title: Text('Add Event',
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
              // Lưu event, kiểm tra các điều kiện nhập đủ chưa
              onPressed: () async {
                if (selectedWallet == null) {
                  _showAlertDialog('Please pick your wallet!');
                } else if (nameEvent == null) {
                  _showAlertDialog('Please enter name!');
                } else if (cate == null) {
                  _showAlertDialog('Please pick category');
                } else if (checkAisBeforeB(endDate, DateTime.now())) {
                  _showAlertDialog(
                      'Please select an end date greater than or equal to today ');
                } else {
                  // Nếu rồi thì khởi tạo 1 event mẫu để thực hiện thêm lên csdl
                  Event event;
                  event = Event(
                    name: nameEvent,
                    endDate: endDate,
                    id: 'id',
                    iconPath: cate.iconID,
                    isFinished: (endDate.year < DateTime.now().year)
                        ? true
                        : (endDate.month < DateTime.now().month)
                            ? true
                            : (endDate.day < DateTime.now().day)
                                ? true
                                : false,
                    finishedByHand: false,
                    walletId: selectedWallet.id,
                    spent: 0,
                    transactionIdList: [],
                    autofinish: true,
                  );
                  await _firestore.addEvent(event, selectedWallet);
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
                primary: Style.foregroundColor,
                backgroundColor: Colors.transparent,
              )),
        ],
      ),
      body: Container(
          color: Style.backgroundColor1,
          child: Form(
            child: buildInput(),
          )),
    );
  }

// Hàm hiện dialog thông báo lên màn hình
  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }

// Là input đầu vào của các giá trị
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
                children: [
                  IconButton(
                    padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                    icon: SuperIcon(
                      iconPath: cate.iconID,
                      size: 40.0,
                    ),
                    // Chọn icon cho sự kiện
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
                    iconSize: 50,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 40.0,
                    ),
                    // Vẫn là chọn icon cho sự kiện :v
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
                    iconSize: 20,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 50),
                      width: 250,
                      // Nhập tên cho event
                      child: TextFormField(
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
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                dense: true,
                leading: SuperIcon(
                  iconPath: 'assets/images/time.svg',
                  size: 30,
                ),
                title: TextFormField(
                  // chọn ngày kết thúc của event
                  onTap: () async {
                    DatePicker.showDatePicker(context,
                        currentTime: endDate == null
                            ? DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day)
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
                        color: endDate == null
                            ? Style.foregroundColor.withOpacity(0.6)
                            : Style.foregroundColor,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight:
                            endDate == null ? FontWeight.w500 : FontWeight.w600,
                      ),
                      hintText: endDate ==
                              DateTime.parse(DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now()))
                          ? 'Today'
                          : endDate ==
                                  DateTime.parse(DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()
                                          .add(Duration(days: 1))))
                              ? 'Tomorrow'
                              : endDate ==
                                      DateTime.parse(DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()
                                              .subtract(Duration(days: 1))))
                                  ? 'Yesterday'
                                  : DateFormat('EEEE, dd-MM-yyyy')
                                      .format(endDate)),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Style.foregroundColor.withOpacity(0.54)),
              ),
              Container(
                margin: EdgeInsets.only(left: 70),
                child: Divider(
                  color: Style.foregroundColor.withOpacity(0.12),
                  thickness: 0.5,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                    size: 20.0, color: Style.foregroundColor.withOpacity(0.54)),
              ),
              Container(
                margin: EdgeInsets.only(left: 70),
                child: Divider(
                  color: Style.foregroundColor.withOpacity(0.12),
                  thickness: 0.5,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                dense: true,
                // Chọn ví cho event
                onTap: () async {
                  var res = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.backgroundColor,
                      context: context,
                      builder: (context) =>
                          SelectWalletScreen(currentWallet: selectedWallet));
                  if (res != null)
                    setState(() {
                      selectedWallet = res;
                    });
                },
                leading: selectedWallet == null
                    ? SuperIcon(
                        iconPath: 'assets/icons/wallet_2.svg', size: 28.0)
                    : SuperIcon(iconPath: selectedWallet.iconID, size: 28.0),
                title: TextFormField(
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
                        color: selectedWallet == null
                            ? Style.foregroundColor.withOpacity(0.6)
                            : Style.foregroundColor,
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
                        backgroundColor: Style.backgroundColor,
                        context: context,
                        builder: (context) =>
                            SelectWalletScreen(currentWallet: selectedWallet));
                    if (res != null)
                      setState(() {
                        selectedWallet = res;
                        currencySymbol = selectedWallet.currencyID;
                      });
                  },
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Style.foregroundColor.withOpacity(0.54)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
