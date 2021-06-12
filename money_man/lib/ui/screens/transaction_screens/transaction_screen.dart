import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/search_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../widgets/custom_select_time_dialog.dart';
import 'adjust_balance_screen.dart';

class TransactionScreen extends StatefulWidget {
  Wallet currentWallet;

  TransactionScreen({Key key, this.currentWallet}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionScreen();
  }
}

class _TransactionScreen extends State<TransactionScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController listScrollController;
  int _limit = 200;
  int _limitIncrement = 20;
  Wallet _wallet;
  bool viewByCategory;
  int choosedTimeRange;
  String currencySymbol;
  List<Tab> myTabs;

  @override
  void initState() {
    super.initState();

    viewByCategory = false;
    choosedTimeRange = 3;
    listScrollController = ScrollController();
    listScrollController.addListener(scrollListener);

    myTabs = initTabBar(choosedTimeRange);

    _tabController = TabController(length: 20, vsync: this, initialIndex: 18);
    _tabController.addListener(() {
      setState(() {});
    });
    _wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg')
        : widget.currentWallet;
    currencySymbol =
        CurrencyService().findByCode(_wallet.currencyID).symbol ?? '';

    var _auth = FirebaseAuthService();
    var _firestore = FirebaseFireStoreService(uid: _auth.currentUser.uid);
    _firestore.executeRecurringTransaction(_wallet);
  }

  @override
  void didUpdateWidget(covariant TransactionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
    currencySymbol =
        CurrencyService().findByCode(_wallet.currencyID).symbol ?? '';
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void _handleSelectTimeRange(int selected) {
    showMenu(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      elevation: 0.0,
      context: context,
      position: RelativeRect.fromLTRB(100, 55, 28, 0),
      items: [
        CheckedPopupMenuItem(
          checked: selected == 1 ? true : false,
          value: 1,
          child: Text(
            "Day",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CheckedPopupMenuItem(
          checked: selected == 2 ? true : false,
          value: 2,
          child: Text(
            "Week",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CheckedPopupMenuItem(
          checked: selected == 3 ? true : false,
          value: 3,
          child: Text(
            "Month",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CheckedPopupMenuItem(
          checked: selected == 4 ? true : false,
          value: 4,
          child: Text(
            "Quarter",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CheckedPopupMenuItem(
          checked: selected == 5 ? true : false,
          value: 5,
          child: Text(
            "Year",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CheckedPopupMenuItem(
          checked: selected == 6 ? true : false,
          value: 6,
          child: Text(
            "All",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CheckedPopupMenuItem(
          checked: selected == 7 ? true : false,
          value: 7,
          child: Text(
            "Custom",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ).then((value) async {
      switch (value) {
        case 1:
          setState(() {
            choosedTimeRange = 1;

            myTabs = initTabBar(choosedTimeRange);
            _tabController =
                TabController(length: 20, vsync: this, initialIndex: 18);
            _tabController.addListener(() {
              setState(() {});
            });
          });
          break;
        case 2:
          setState(() {
            choosedTimeRange = 2;
            myTabs = initTabBar(choosedTimeRange);
            _tabController =
                TabController(length: 20, vsync: this, initialIndex: 18);
            _tabController.addListener(() {
              setState(() {});
            });
          });
          break;
        case 3:
          setState(() {
            choosedTimeRange = 3;
            myTabs = initTabBar(choosedTimeRange);
            _tabController =
                TabController(length: 20, vsync: this, initialIndex: 18);
            _tabController.addListener(() {
              setState(() {});
            });
          });
          break;
        case 4:
          setState(() {
            choosedTimeRange = 4;
            myTabs = initTabBar(choosedTimeRange);
            _tabController =
                TabController(length: 20, vsync: this, initialIndex: 18);
            _tabController.addListener(() {
              setState(() {});
            });
          });
          break;
        case 5:
          setState(() {
            choosedTimeRange = 5;
            myTabs = initTabBar(choosedTimeRange);
            _tabController =
                TabController(length: 20, vsync: this, initialIndex: 18);
            _tabController.addListener(() {
              setState(() {});
            });
          });
          break;
        case 6:
          setState(() {
            choosedTimeRange = 6;
            myTabs = initTabBar(choosedTimeRange);
            _tabController =
                TabController(length: 1, vsync: this, initialIndex: 0);
            _tabController.addListener(() {
              setState(() {});
            });
          });
          break;
        case 7:
          List<DateTime> timeRange = [];
          await showDialog(
              context: context,
              builder: (builder) {
                return CustomSelectTimeDialog();
              }).then((value) => timeRange = value);

          if (timeRange == null) return null;

          String displayTab = DateFormat('dd/MM/yyyy').format(timeRange[0]) +
              " - " +
              DateFormat('dd/MM/yyyy').format(timeRange[1]);

          setState(() {
            choosedTimeRange = 7;
            myTabs = initTabBar(choosedTimeRange, extraInfo: displayTab);
            _tabController =
                TabController(length: 1, vsync: this, initialIndex: 0);
            _tabController.addListener(() {
              setState(() {});
            });
          });

          break;
      }
    });
  }

  List<Tab> initTabBar(int choosedTimeRange, {var extraInfo}) {
    if (choosedTimeRange == 3) {
      return List.generate(20, (index) {
        var now = DateTime.now();
        if (index == 17) {
          return Tab(
            text: 'LAST MONTH',
          );
        } else if (index == 18) {
          return Tab(
            text: 'THIS MONTH',
          );
        } else if (index == 19) {
          return Tab(
            text: 'FUTURE',
          );
        } else {
          var date = DateTime(now.year, now.month - (18 - index), now.day);
          String dateDisplay = DateFormat('MM/yyyy').format(date);
          return Tab(
            text: dateDisplay,
          );
        }
      });
    } else if (choosedTimeRange == 1) {
      return List.generate(20, (index) {
        var now = DateTime.now();
        if (index == 17) {
          return Tab(
            text: 'YESTERDAY',
          );
        } else if (index == 18) {
          return Tab(
            text: 'TODAY',
          );
        } else if (index == 19) {
          return Tab(
            text: 'FUTURE',
          );
        } else {
          var date = DateTime(now.year, now.month, now.day - (18 - index));
          String dateDisplay = DateFormat('dd MMMM yyyy').format(date);
          return Tab(
            text: dateDisplay,
          );
        }
      });
    } else if (choosedTimeRange == 2) {
      return List.generate(20, (index) {
        var now = DateTime.now();
        if (index == 17) {
          return Tab(
            text: 'LAST WEEK',
          );
        } else if (index == 18) {
          return Tab(
            text: 'THIS WEEK',
          );
        } else if (index == 19) {
          return Tab(
            text: 'FUTURE',
          );
        } else {
          var firstDateInAWeek = DateTime.now()
              .subtract(Duration(days: DateTime.now().weekday - 1))
              .subtract(Duration(days: 7 * (18 - index)));
          String firstDateDisplay =
              DateFormat('dd/MM').format(firstDateInAWeek);

          var lastDateInAWeek = firstDateInAWeek.add(Duration(days: 6));
          String lastDateDisplay = DateFormat('dd/MM').format(lastDateInAWeek);

          return Tab(text: firstDateDisplay + ' - ' + lastDateDisplay);
        }
      });
    } else if (choosedTimeRange == 4) {
      var now = DateTime.now();
      int year = now.year;
      int initQuarter = ((now.month + 2) / 3).toInt();
      int k = 0;

      List<String> list = [];

      for (var i = 0; i < 20; i++) {
        var q = initQuarter - i + 4 * k + 1;
        list.add('Q$q $year');
        if (q == 1) {
          k = k + 1;
          year = year - 1;
        }
      }
      list = list.reversed.toList();

      return List.generate(20, (index) {
        if (index == 19) {
          return Tab(
            text: 'FUTURE',
          );
        } else {
          // String dateDisplay = DateFormat('yyyy').format(date);
          String display = list[index];
          return Tab(
            text: display,
          );
        }
      });
    } else if (choosedTimeRange == 5) {
      return List.generate(20, (index) {
        var now = DateTime.now();
        if (index == 17) {
          return Tab(
            text: 'LAST YEAR',
          );
        } else if (index == 18) {
          return Tab(
            text: 'THIS YEAR',
          );
        } else if (index == 19) {
          return Tab(
            text: 'FUTURE',
          );
        } else {
          var date = DateTime(now.year, now.month, now.day - (18 - index));
          String dateDisplay = DateFormat('yyyy').format(date);
          return Tab(
            text: dateDisplay,
          );
        }
      });
    } else if (choosedTimeRange == 6) {
      return List.generate(1, (index) {
        return Tab(
          text: 'All transactions',
        );
      });
    } else {
      return List.generate(1, (index) {
        return Tab(
          text: extraInfo,
        );
      });
    }
  }

  List<MyTransaction> sortTransactionBasedOnTime(
      int choosedTimeRange, List<MyTransaction> _transactionList) {
    if (choosedTimeRange == 3) {
      // thời gian được chọn từ tab bar
      var chooseTime = myTabs[_tabController.index].text.split('/');
      // biến để xác định tab hiện tại có là tab future hay không ?
      bool isFutureTab = false;

      // trường hợp rơi vào tab THIS MONTH, LAST MONTH, FUTURE
      if (chooseTime.length == 1) {
        chooseTime.clear();
        int nowMonth = DateTime.now().month;
        int nowYear = DateTime.now().year;
        // LAST MONTH (lấy tháng trước hiện tại)
        if (_tabController.index == 17) {
          chooseTime.add((nowMonth - 1).toString());
          chooseTime.add(nowYear.toString());
        }
        // THIS MONTH (lấy tháng hiện tại)
        else if (_tabController.index == 18) {
          chooseTime.add((nowMonth).toString());
          chooseTime.add(nowYear.toString());
        }
        // FUTURE (lấy những tháng sau hiện tại)
        else {
          chooseTime.add((nowMonth + 1).toString());
          chooseTime.add(nowYear.toString());
          isFutureTab = true;
        }
      }

      // trường hợp tab FUTURE thì lấy những transaction có tháng
      // tháng hiện tại
      if (isFutureTab) {
        DateTime time =
            DateTime(int.parse(chooseTime[1]), int.parse(chooseTime[0]));

        _transactionList = _transactionList
            .where((element) => element.date.compareTo(time) > 0)
            .toList();
        isFutureTab = false;
      }
      // còn lại thì lấy bằng tháng đã lấy trong chooseTime
      else {
        _transactionList = _transactionList
            .where((element) =>
                element.date.month == int.parse(chooseTime[0]) &&
                element.date.year == int.parse(chooseTime[1]))
            .toList();
      }
      return _transactionList;
    } else if (choosedTimeRange == 1) {
      // thời gian được chọn từ tab bar
      var chooseTime = myTabs[_tabController.index].text.split(' ');

      // biến để xác định tab hiện tại có là tab future hay không ?
      bool isFutureTab = false;

      // trường hợp rơi vào tab THIS MONTH, LAST MONTH, FUTURE
      if (chooseTime.length == 1) {
        chooseTime.clear();
        int nowDay = DateTime.now().day;
        int nowMonth = DateTime.now().month;
        int nowYear = DateTime.now().year;
        // LAST MONTH (lấy tháng trước hiện tại)
        if (_tabController.index == 17) {
          chooseTime.add((nowDay - 1).toString());
          chooseTime.add((nowMonth).toString());
          chooseTime.add(nowYear.toString());
        }
        // THIS MONTH (lấy tháng hiện tại)
        else if (_tabController.index == 18) {
          chooseTime.add((nowDay).toString());
          chooseTime.add((nowMonth).toString());
          chooseTime.add(nowYear.toString());
        }
        // FUTURE (lấy những tháng sau hiện tại)
        else {
          chooseTime.add((nowDay + 1).toString());
          chooseTime.add((nowMonth).toString());
          chooseTime.add(nowYear.toString());
          isFutureTab = true;
        }
      } else {
        switch (chooseTime[1]) {
          case 'January':
            chooseTime[1] = '1';
            break;
          case 'February':
            chooseTime[1] = '2';
            break;
          case 'March':
            chooseTime[1] = '3';
            break;
          case 'April':
            chooseTime[1] = '4';
            break;
          case 'May':
            chooseTime[1] = '5';
            break;
          case 'June':
            chooseTime[1] = '6';
            break;
          case 'July':
            chooseTime[1] = '7';
            break;
          case 'August':
            chooseTime[1] = '8';
            break;
          case 'September':
            chooseTime[1] = '9';
            break;
          case 'October':
            chooseTime[1] = '10';
            break;
          case 'November':
            chooseTime[1] = '11';
            break;
          case 'December':
            chooseTime[1] = '12';
            break;
          default:
        }
      }

      // trường hợp tab FUTURE thì lấy những transaction có tháng
      // tháng hiện tại
      if (isFutureTab) {
        DateTime futureTime = DateTime(int.parse(chooseTime[2]),
            int.parse(chooseTime[1]), int.parse(chooseTime[0]));
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(futureTime) > 0)
            .toList();
        isFutureTab = false;
      }
      // còn lại thì lấy bằng tháng đã lấy trong chooseTime
      else {
        DateTime time = DateTime(int.parse(chooseTime[2]),
            int.parse(chooseTime[1]), int.parse(chooseTime[0]));
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(time) == 0)
            .toList();
      }
      return _transactionList;
    } else if (choosedTimeRange == 2) {
      List<String> chooseTime = [];
      chooseTime = myTabs[_tabController.index].text.split(' - ');

      bool isFutureTab = false;

      var headDateList;
      DateTime headTime;
      DateTime tailTime;

      if (chooseTime.length == 1) {
        chooseTime.clear();

        var firstDatePresent = DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: DateTime.now().weekday - 1));
        var lastDatePresent = firstDatePresent.add(Duration(days: 6));

        var firstDateInPast = firstDatePresent.subtract(Duration(days: 7));
        var lastDateInPast = firstDateInPast.add(Duration(days: 6));

        var firstDateInFutre = firstDatePresent.add(Duration(days: 7));

        // LAST MONTH (lấy tháng trước hiện tại)
        if (_tabController.index == 17) {
          headTime = firstDateInPast;
          tailTime = lastDateInPast;
        }
        // THIS MONTH (lấy tháng hiện tại)
        else if (_tabController.index == 18) {
          headTime = firstDatePresent;
          tailTime = lastDatePresent;
        }
        // FUTURE (lấy những tháng sau hiện tại)
        else {
          headTime = firstDateInFutre;
          isFutureTab = true;
        }
      } else {
        headDateList = chooseTime[0].split('/');
        headTime = DateTime(DateTime.now().year, int.parse(headDateList[1]),
            int.parse(headDateList[0]));
        tailTime = headTime.add(Duration(days: 6));
      }

      if (isFutureTab) {
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(headTime) >= 0)
            .toList();
        isFutureTab = false;
      } else {
        _transactionList = _transactionList
            .where((element) =>
                element.date.compareTo(headTime) >= 0 &&
                element.date.compareTo(tailTime) <= 0)
            .toList();
      }

      return _transactionList;
    } else if (choosedTimeRange == 4) {
      var chooseTime = myTabs[_tabController.index].text.split(' ');

      DateTime headTime;
      DateTime tailTime;
      DateTime now = DateTime.now();
      bool isFutureTab = false;

      if (chooseTime.length == 1) {
        isFutureTab = true;
        var x = myTabs[_tabController.index - 1].text.split(' ');

        switch (x[0]) {
          case 'Q1':
            headTime = DateTime(now.year, DateTime.april);
            break;
          case 'Q2':
            headTime = DateTime(now.year, DateTime.july);
            break;
          case 'Q3':
            headTime = DateTime(now.year, DateTime.october);
            break;
          case 'Q4':
            headTime = DateTime(now.year + 1, DateTime.january);
            break;
          default:
        }
      } else {
        switch (chooseTime[0]) {
          case 'Q1':
            headTime = DateTime(now.year, DateTime.january);
            tailTime = DateTime(now.year, DateTime.march);
            break;
          case 'Q2':
            headTime = DateTime(now.year, DateTime.april);
            tailTime = DateTime(now.year, DateTime.june);
            break;
          case 'Q3':
            headTime = DateTime(now.year, DateTime.july);
            tailTime = DateTime(now.year, DateTime.september);
            break;
          case 'Q4':
            headTime = DateTime(now.year, DateTime.october);
            tailTime = DateTime(now.year, DateTime.december);
            break;
          default:
        }
      }

      if (isFutureTab) {
        isFutureTab = false;
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(headTime) >= 0)
            .toList();
      } else {
        _transactionList = _transactionList
            .where((element) =>
                element.date.compareTo(headTime) >= 0 &&
                element.date.compareTo(tailTime) <= 0)
            .toList();
      }

      return _transactionList;
    } else if (choosedTimeRange == 5) {
      // thời gian được chọn từ tab bar
      var chooseTime = myTabs[_tabController.index].text;
      // biến để xác định tab hiện tại có là tab future hay không ?
      bool isFutureTab = false;

      var tempt = int.tryParse(chooseTime);
      if (tempt == null) {
        if (chooseTime == 'LAST YEAR') {
          chooseTime = (DateTime.now().year - 1).toString();
        } else if (chooseTime == 'THIS YEAR') {
          chooseTime = (DateTime.now().year).toString();
        } else {
          chooseTime = (DateTime.now().year + 1).toString();
          isFutureTab = true;
        }
      }

      // trường hợp tab FUTURE thì lấy những transaction có tháng
      // tháng hiện tại
      if (isFutureTab) {
        _transactionList = _transactionList
            .where((element) => element.date.year >= int.parse(chooseTime))
            .toList();
        isFutureTab = false;
      }
      // còn lại thì lấy bằng tháng đã lấy trong chooseTime
      else {
        _transactionList = _transactionList
            .where((element) => element.date.year == int.parse(chooseTime))
            .toList();
      }
      return _transactionList;
    } else if (choosedTimeRange == 6) {
      return _transactionList;
    } else {
      var chooseTime = myTabs[_tabController.index].text.split(' - ');
      DateTime head;
      DateTime tail;

      var headList = chooseTime[0].split('/');
      head = DateTime(int.parse(headList[2]), int.parse(headList[1]),
          int.parse(headList[0]));

      var tailList = chooseTime[1].split('/');
      tail = DateTime(int.parse(tailList[2]), int.parse(tailList[1]),
          int.parse(tailList[0]));

      _transactionList = _transactionList
          .where((element) =>
              element.date.compareTo(head) >= 0 &&
              element.date.compareTo(tail) <= 0)
          .toList();
      return _transactionList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    print('transaction build ' + _wallet.amount.toString());

    // _firestore.executeRecurringTransaction(_wallet);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 70,
          leading: GestureDetector(
            onTap: () async {
              buildShowDialog(context, _wallet.id);
            },
            child: Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  SuperIcon(
                    iconPath: _wallet.iconID,
                    size: 25.0,
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey)
                ],
              ),
            ),
          ),
          title: Column(children: [
            Text(_wallet.name,
                style: TextStyle(color: Colors.grey[500], fontSize: 10.0)),
            Text(
                MoneyFormatter(amount: _wallet.amount)
                        .output
                        .withoutFractionDigits +
                    ' ' +
                    currencySymbol,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold)),
          ]),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey[500],
            labelColor: Colors.white,
            indicatorColor: Color(0xff2FB49C),
            physics: AlwaysScrollableScrollPhysics(),
            isScrollable: true,
            indicatorWeight: 3.0,
            controller: _tabController,
            tabs: myTabs,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.grey),
              tooltip: 'Notify',
              onPressed: () {},
            ),
            PopupMenuButton(
                padding: EdgeInsets.all(10.0),
                //icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                offset: Offset.fromDirection(40, 40),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                elevation: 0.0,
                onSelected: (value) {
                  if (value == 'Search for transaction') {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            SearchTransactionScreen(wallet: _wallet));
                  } else if (value == 'change display') {
                    setState(() {
                      viewByCategory = !viewByCategory;
                    });
                  } else if (value == 'Adjust Balance') {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            AdjustBalanceScreen(wallet: _wallet));
                  } else if (value == 'Select time range') {
                    _handleSelectTimeRange(choosedTimeRange);
                  }
                },
                itemBuilder: (context) {
                  print('popup build');
                  return [
                    PopupMenuItem(
                        value: 'Select time range',
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              'Select time range',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'change display',
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              viewByCategory
                                  ? 'View by transaction'
                                  : 'View by category',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'Adjust Balance',
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              'Adjust Balance',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'Transfer money',
                        child: Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              'Transfer money',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'Search for transaction',
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              'Search for transaction',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'Synchronize',
                        child: Row(
                          children: [
                            Icon(Icons.sync, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              'Synchronize',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )),
                  ];
                })
          ],
        ),
        body: StreamBuilder<List<MyTransaction>>(
            stream: _firestore.transactionStream(_wallet, _limit),
            builder: (context, snapshot) {
              print('streambuilder build');
              List<MyTransaction> _transactionList = snapshot.data ?? [];

              _transactionList = sortTransactionBasedOnTime(
                  choosedTimeRange, _transactionList);

              // list những ngày trong các transaction đã lọc
              List<DateTime> dateInChoosenTime = [];
              // list những category trong các transaction đã lọc
              List<String> categoryInChoosenTime = [];

              // tổng đầu vào, tổng đầu ra, hiệu
              double totalInCome = 0;
              double totalOutCome = 0;
              double total = 0;

              // list các list transaction đã lọc
              List<List<MyTransaction>> transactionListSorted = [];

              // sort theo date giảm dần
              _transactionList.sort((a, b) => b.date.compareTo(a.date));

              // trường hợp hiển thị category
              if (viewByCategory) {
                _transactionList.forEach((element) {
                  // lấy các category trong transaction đã lọc
                  if (!categoryInChoosenTime.contains(element.category.name))
                    categoryInChoosenTime.add(element.category.name);
                  // tính toán đầu vào, đầu ra
                  if (element.category.type == 'expense')
                    totalOutCome += element.amount;
                  else
                    totalInCome += element.amount;
                });
                // totalInCome += _wallet.amount > 0 ? _wallet.amount : 0;
                total = totalInCome - totalOutCome;

                // lấy các transaction ra theo từng category
                categoryInChoosenTime.forEach((cate) {
                  final b = _transactionList.where(
                      (element) => element.category.name.compareTo(cate) == 0);
                  transactionListSorted.add(b.toList());
                });
              }
              // trường hợp hiển thị theo date (tương tự)
              else {
                _transactionList.forEach((element) {
                  if (!dateInChoosenTime.contains(element.date))
                    dateInChoosenTime.add(element.date);
                  if (element.category.type == 'expense')
                    totalOutCome += element.amount;
                  else
                    totalInCome += element.amount;
                });
                // totalInCome += _wallet.amount > 0 ? _wallet.amount : 0;
                total = totalInCome - totalOutCome;

                dateInChoosenTime.forEach((date) {
                  final b = _transactionList
                      .where((element) => element.date.compareTo(date) == 0);
                  transactionListSorted.add(b.toList());
                });
              }

              return TabBarView(
                controller: _tabController,
                children: myTabs.map((tab) {
                  return viewByCategory == true
                      ? buildDisplayTransactionByCategory(transactionListSorted,
                          totalInCome, totalOutCome, total)
                      : buildDisplayTransactionByDate(transactionListSorted,
                          totalInCome, totalOutCome, total);
                }).toList(),
              );
            }));
  }

  Container buildDisplayTransactionByCategory(
      List<List<MyTransaction>> transactionListSortByCategory,
      double totalInCome,
      double totalOutCome,
      double total) {
    print('build function');
    return Container(
      color: Colors.black,
      child: ListView.builder(
          controller: listScrollController,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactionListSortByCategory.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            transactionListSortByCategory[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(totalInCome, totalOutCome, total),
                      buildBottomViewByCategory(transactionListSortByCategory,
                          xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByCategory(
                    transactionListSortByCategory, xIndex, totalAmountInDay);
          }),
    );
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate,
      double totalInCome,
      double totalOutCome,
      double total) {
    print('build function');
    return Container(
      color: Colors.black,
      child: ListView.builder(
          controller: listScrollController,
          physics: BouncingScrollPhysics(),
          //primary: false,
          shrinkWrap: true,
          // itemCount: TRANSACTION_DATA.length + 1,
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            transactionListSortByDate[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(totalInCome, totalOutCome, total),
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  Container buildBottomViewByCategory(
      List<List<MyTransaction>> transListSortByCategory,
      int xIndex,
      double totalAmountInDay) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              top: BorderSide(
                color: Colors.black,
                width: 1.0,
              ))),
      child: StickyHeader(
        header: Container(
          color: Colors.grey[900],
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: SuperIcon(
                    iconPath:
                        transListSortByCategory[xIndex][0].category.iconID,
                    size: 35.0,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Text(
                    transListSortByCategory[xIndex][0].category.name +
                        '\n' +
                        transListSortByCategory[xIndex].length.toString() +
                        ' transactions',
                    // 'hello',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
              ),
              Expanded(
                child: Text(totalAmountInDay.toString() + ' $currencySymbol',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
        content: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transListSortByCategory[xIndex].length,
            itemBuilder: (context, yIndex) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransactionDetail(
                                transaction: transListSortByCategory[xIndex]
                                    [yIndex],
                                wallet: widget.currentWallet,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Text(
                            DateFormat("dd").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                            DateFormat("MMMM yyyy, EEEE").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                        child: Text(
                            transListSortByCategory[xIndex][yIndex].category.type == 'income' ||
                                    transListSortByCategory[xIndex][yIndex].category.name ==
                                        'Debt' ||
                                    transListSortByCategory[xIndex][yIndex].category.name ==
                                        'Deft Collection'
                                ? '+' +
                                    transListSortByCategory[xIndex][yIndex]
                                        .amount
                                        .toString() +
                                    ' $currencySymbol'
                                : '-' +
                                    transListSortByCategory[xIndex][yIndex]
                                        .amount
                                        .toString() +
                                    ' $currencySymbol',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transListSortByCategory[xIndex][yIndex]
                                                .category
                                                .type ==
                                            'income' ||
                                        transListSortByCategory[xIndex][yIndex]
                                                .category
                                                .name ==
                                            'Debt' ||
                                        transListSortByCategory[xIndex][yIndex]
                                                .category
                                                .name ==
                                            'Deft Collection'
                                    ? Colors.green
                                    : Colors.red[600])),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Container buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
    print('build bottom by date');
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              top: BorderSide(
                color: Colors.black,
                width: 1.0,
              ))),
      child: StickyHeader(
        header: Container(
          color: Colors.grey[900],
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                    DateFormat("dd")
                        .format(transListSortByDate[xIndex][0].date),
                    style: TextStyle(fontSize: 30.0, color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Text(
                    DateFormat("EEEE")
                            .format(transListSortByDate[xIndex][0].date)
                            .toString() +
                        '\n' +
                        DateFormat("MMMM yyyy")
                            .format(transListSortByDate[xIndex][0].date)
                            .toString(),
                    // 'hello',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
              ),
              Expanded(
                child: Text(totalAmountInDay.toString() + ' $currencySymbol',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
        content: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transListSortByDate[xIndex].length,
            itemBuilder: (context, yIndex) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            transaction: transListSortByDate[xIndex][yIndex],
                            wallet: widget.currentWallet,
                          ),
                          type: PageTransitionType.rightToLeft));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: SuperIcon(
                          iconPath: transListSortByDate[xIndex][yIndex]
                              .category
                              .iconID,
                          size: 35.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                            transListSortByDate[xIndex][yIndex].category.name,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                        child: Text(
                            transListSortByDate[xIndex][yIndex].category.type ==
                                        'income' ||
                                    transListSortByDate[xIndex][yIndex]
                                            .category
                                            .name ==
                                        'Debt' ||
                                    transListSortByDate[xIndex][yIndex]
                                            .category
                                            .name ==
                                        'Deft Collection'
                                ? "${"+" + transListSortByDate[xIndex][yIndex].amount.toString()} $currencySymbol"
                                : "${"-" + (transListSortByDate[xIndex][yIndex].amount).toString()} $currencySymbol",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transListSortByDate[xIndex][yIndex]
                                                .category
                                                .type ==
                                            'income' ||
                                        transListSortByDate[xIndex][yIndex]
                                                .category
                                                .name ==
                                            'Debt' ||
                                        transListSortByDate[xIndex][yIndex]
                                                .category
                                                .name ==
                                            'Deft Collection'
                                    ? Colors.green
                                    : Colors.red[600])),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  StickyHeader buildHeader(
      double totalInCome, double totalOutCome, double total) {
    print('build header');
    return StickyHeader(
      header: SizedBox(height: 0),
      content: Container(
          decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                  bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ))),
          padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Inflow', style: TextStyle(color: Colors.grey[500])),
                  Text('+$totalInCome $currencySymbol',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Outflow', style: TextStyle(color: Colors.grey[500])),
                    Text('-$totalOutCome $currencySymbol',
                        style: TextStyle(color: Colors.white)),
                  ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0,
                      height: 10,
                    ),
                    ColoredBox(color: Colors.black87)
                  ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text('$total $currencySymbol',
                        style: TextStyle(color: Colors.white)),
                  ]),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View report for this period',
                style: TextStyle(color: Color(0xff36D1B5)),
              ),
              style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            )
          ])),
    );
  }

  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.grey[900],
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: _auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}
