import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/search_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/report_for_this_period.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
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
  // tab controller để điều khiển tab
  TabController _tabController;
  // ScrollController listScrollController;
  // biến wallet hiện tại
  Wallet wallet;
  // biến điều khiển việc hiển thị transaction ở dạng view by category hay view by date
  bool viewByCategory;
  // biến điều khiển cách phân chia tab
  int choosedTimeRange;
  // ký tự đơn vị tiền tệ của các transaction
  String currencySymbol;
  // list các tab
  List<Tab> myTabs;
  // danh sách các thời điểm bắt đầu phục vụ chức năng 'View report for this period'
  List<DateTime> beginDate = [];
  // danh sách các thời điểm kết thức phục vụ chức năng 'View report for this period'
  List<DateTime> endDate = [];

  @override
  void initState() {
    super.initState();

    viewByCategory = false;
    choosedTimeRange = 3;
    beginDate.clear();
    endDate.clear();

    // set up lấy các begin date
    int index = 0;
    var now = DateTime.now();
    for (; index < 20; index++) {
      var date = DateTime(now.year, now.month - (18 - index), 1);
      beginDate.add(date);
      if (index < 19) {
        endDate.add(DateTime(
          beginDate[index].year,
          beginDate[index].month + 1,
          beginDate[index].day - 1,
        ));
      }
    }
    // listScrollController = ScrollController();
    // listScrollController.addListener(scrollListener);

    myTabs = initTabBar(choosedTimeRange);
    _tabController = TabController(length: 20, vsync: this, initialIndex: 18);
    _tabController.addListener(() {
      setState(() {});
    });
    wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg')
        : widget.currentWallet;
    currencySymbol =
        CurrencyService().findByCode(wallet.currencyID).symbol ?? '';

    // check và thực hiện các recurring transaction nếu có
    var auth = FirebaseAuthService();
    var firestore = FirebaseFireStoreService(uid: auth.currentUser.uid);
    firestore.executeRecurringTransaction(wallet);
  }

  @override
  void didUpdateWidget(covariant TransactionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
    currencySymbol =
        CurrencyService().findByCode(wallet.currencyID).symbol ?? '';
  }

  // void scrollListener() {
  //   // if (listScrollController.offset >=
  //   //         listScrollController.position.maxScrollExtent &&
  //   //     !listScrollController.position.outOfRange) {
  //   //   setState(() {
  //   //     _limit += _limitIncrement;
  //   //   });
  //   // }
  // }

  // xử lý khi thay đổi time range
  void handleSelectTimeRange(int selected) {
    showMenu(
      color: Style.foregroundColor,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
              color: Style.backgroundColor,
              fontFamily: Style.fontFamily,
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
            beginDate.clear();
            endDate.clear();
            int index = 0;
            var now = DateTime.now();
            for (; index < 20; index++) {
              var date = DateTime(now.year, now.month, now.day - (18 - index));
              beginDate.add(date);
              if (index < 19) {
                endDate.add(date);
              }
            }
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
            beginDate.clear();
            endDate.clear();
            int index = 0;
            for (; index < 20; index++) {
              var firstDateInAWeek = DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1))
                  .subtract(Duration(days: 7 * (18 - index)));
              beginDate.add(firstDateInAWeek);
              if (index < 19) {
                endDate.add(DateTime(
                  firstDateInAWeek.year,
                  firstDateInAWeek.month,
                  firstDateInAWeek.day + 6,
                ));
              }
            }
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
            beginDate.clear();
            endDate.clear();
            int index = 0;
            var now = DateTime.now();
            for (; index < 20; index++) {
              var date = DateTime(now.year, now.month - (18 - index), 1);
              beginDate.add(date);
              if (index < 19) {
                endDate.add(DateTime(
                  beginDate[index].year,
                  beginDate[index].month + 1,
                  beginDate[index].day - 1,
                ));
              }
            }
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
            beginDate.clear();
            endDate.clear();
            int index = 0;
            var now = DateTime.now();
            var initQuater = (now.month + 2) % 3;
            for (; index < 20; index++) {
              beginDate.add(DateTime(
                now.year,
                now.month - initQuater - (18 - index) * 3,
                1,
              ));
              if (index < 19) {
                endDate.add(DateTime(
                  beginDate[index].year,
                  beginDate[index].month + 3,
                  beginDate[index].day - 1,
                ));
              }
            }
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
            beginDate.clear();
            endDate.clear();
            int index = 0;
            var now = DateTime.now();
            for (; index < 20; index++) {
              beginDate.add(DateTime(
                now.year - (18 - index),
                1,
                1,
              ));
              if (index < 19) {
                endDate.add(DateTime(
                  beginDate[index].year,
                  12,
                  31,
                ));
              }
            }
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
            beginDate.clear();
            endDate.clear();
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
          beginDate.clear();
          endDate.clear();
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
          beginDate.add(timeRange[0]);
          endDate.add(timeRange[1]);
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

  // tạo tab bar
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

  // lọc danh sách các transaction dựa trên time range
  List<MyTransaction> sortTransactionBasedOnTime(
      int choosedTimeRange, List<MyTransaction> _transactionList) {
    // TRƯỜNG HỢP "MONTH"
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

      // trường hợp tab FUTURE thì lấy những transaction có tháng > tháng hiện tại
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
    }
    // TRƯỜNG HỢP "DAY"
    else if (choosedTimeRange == 1) {
      // thời gian được chọn từ tab bar
      // tách từ tab thì lấy được 3 phần tử
      // chooseTime[0] = ngày
      // chooseTime[1] = tháng
      // chooseTime[2] = năm
      var chooseTime = myTabs[_tabController.index].text.split(' ');

      // biến để xác định tab hiện tại có là tab future hay không ?
      bool isFutureTab = false;

      // trường hợp rơi vào tab YESTERDAY, TODAY, FUTURE
      if (chooseTime.length == 1) {
        chooseTime.clear();
        int nowDay = DateTime.now().day;
        int nowMonth = DateTime.now().month;
        int nowYear = DateTime.now().year;
        // YESTERDAY (lấy ngày trước hiện tại)
        if (_tabController.index == 17) {
          chooseTime.add((nowDay - 1).toString());
          chooseTime.add((nowMonth).toString());
          chooseTime.add(nowYear.toString());
        }
        // TODAY (lấy ngày hiện tại)
        else if (_tabController.index == 18) {
          chooseTime.add((nowDay).toString());
          chooseTime.add((nowMonth).toString());
          chooseTime.add(nowYear.toString());
        }
        // FUTURE (lấy những ngày sau hiện tại)
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

      // trường hợp tab FUTURE thì lấy những transaction có ngày, tháng sau mốc hiên tại
      if (isFutureTab) {
        DateTime futureTime = DateTime(int.parse(chooseTime[2]),
            int.parse(chooseTime[1]), int.parse(chooseTime[0]));
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(futureTime) > 0)
            .toList();
        isFutureTab = false;
      }
      // còn lại thì lấy bằng mốc (ngày/tháng/năm) đã lấy trong chooseTime
      else {
        DateTime time = DateTime(int.parse(chooseTime[2]),
            int.parse(chooseTime[1]), int.parse(chooseTime[0]));
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(time) == 0)
            .toList();
      }
      return _transactionList;
    }
    // TRƯỜNG HỢP "WEEK"
    else if (choosedTimeRange == 2) {
      // thời gian tách từ tab bar
      // sẽ tách được 2 mốc thời gian
      // chooseTime[i] = ngày/năm
      List<String> chooseTime = [];
      chooseTime = myTabs[_tabController.index].text.split(' - ');

      // biến xác định có phải là tab future hay không?
      bool isFutureTab = false;

      // biến chứa mốc thời gian (ngày/tháng) ở giá trị đầu của chooseTime
      var headDateList;
      // mốc thời gian đầu
      DateTime headTime;
      // mốc  thời gian cuối
      DateTime tailTime;

      // trường hợp LAST WEEK, THIS WEEK, FUTURE
      if (chooseTime.length == 1) {
        chooseTime.clear();

        // mốc thời gian đầu của THIS WEEK
        var firstDatePresent = DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: DateTime.now().weekday - 1));
        // mốc thời gian cuối của THIS WEEK
        var lastDatePresent = firstDatePresent.add(Duration(days: 6));

        // mốc thời gian đầu của LAST WEEK
        var firstDateInPast = firstDatePresent.subtract(Duration(days: 7));
        // mốc thời gian cuối của LAST WEEK
        var lastDateInPast = firstDateInPast.add(Duration(days: 6));

        // mốc thời gian đầu của FUTURE
        var firstDateInFutre = firstDatePresent.add(Duration(days: 7));

        // LAST WEEK (lấy tuần trước hiện tại)
        if (_tabController.index == 17) {
          headTime = firstDateInPast;
          tailTime = lastDateInPast;
        }
        // THIS WEEK (lấy tuần hiện tại)
        else if (_tabController.index == 18) {
          headTime = firstDatePresent;
          tailTime = lastDatePresent;
        }
        // FUTURE (lấy những tuần sau hiện tại)
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

      // trường hợp future (lấy các transaction lớn hơn mốc headTime)
      if (isFutureTab) {
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(headTime) >= 0)
            .toList();
        isFutureTab = false;
      }
      // trường hợp còn lại (lấy các transaction lớn hơn mốc headTime và bé hơn mốc tailTime)
      else {
        _transactionList = _transactionList
            .where((element) =>
                element.date.compareTo(headTime) >= 0 &&
                element.date.compareTo(tailTime) <= 0)
            .toList();
      }

      return _transactionList;
    }
    // TRƯỜNG HỢP "QUARTER"
    else if (choosedTimeRange == 4) {
      // thời gian tách từ tab bar
      // sẽ tách được 2 mốc thời gian
      // chooseTime[0] = Qi
      // chooseTime[1] = năm
      var chooseTime = myTabs[_tabController.index].text.split(' ');

      // mốc thời gian đầu
      DateTime headTime;
      // mốc thời gian cuối
      DateTime tailTime;
      DateTime now = DateTime.now();
      // biến chứa mốc thời gian (ngày/tháng) ở giá trị đầu của chooseTime
      bool isFutureTab = false;

      // trường hợp FUTURE
      if (chooseTime.length == 1) {
        isFutureTab = true;
        // lấy mốc thời gian của tab liền trước để xác định thời gian hiện tại
        // x là list gồm 2 giá trị x[0] = Qi, x[1] = năm
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
            headTime = DateTime(now.year, DateTime.january, 1);
            tailTime = DateTime(now.year, DateTime.march, 31);
            break;
          case 'Q2':
            headTime = DateTime(now.year, DateTime.april, 1);
            tailTime = DateTime(now.year, DateTime.june, 30);
            break;
          case 'Q3':
            headTime = DateTime(now.year, DateTime.july, 1);
            tailTime = DateTime(now.year, DateTime.september, 30);
            break;
          case 'Q4':
            headTime = DateTime(now.year, DateTime.october, 1);
            tailTime = DateTime(now.year, DateTime.december, 31);
            break;
          default:
        }
      }

      // trường hợp future (lấy các transaction lớn hơn mốc headTime)
      if (isFutureTab) {
        isFutureTab = false;
        _transactionList = _transactionList
            .where((element) => element.date.compareTo(headTime) >= 0)
            .toList();
      }
      // trường hợp còn lại (lấy các transaction lớn hơn mốc headTime và bé hơn mốc tailTime)
      else {
        _transactionList = _transactionList
            .where((element) =>
                element.date.compareTo(headTime) >= 0 &&
                element.date.compareTo(tailTime) <= 0)
            .toList();
      }

      return _transactionList;
    }
    // TRƯỜNG HỢP "YEAR"
    else if (choosedTimeRange == 5) {
      // thời gian được chọn từ tab bar
      // sẽ cho ra chooseTime = năm
      var chooseTime = myTabs[_tabController.index].text;
      // biến để xác định tab hiện tại có là tab future hay không ?
      bool isFutureTab = false;

      // xác định giá trị chooseTime là future hay năm
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

      // trường hợp tab FUTURE thì lấy những transaction có năm lớn hơn chooseTime
      if (isFutureTab) {
        _transactionList = _transactionList
            .where((element) => element.date.year >= int.parse(chooseTime))
            .toList();
        isFutureTab = false;
      }
      // còn lại thì lấy bằng năm đã lấy trong chooseTime
      else {
        _transactionList = _transactionList
            .where((element) => element.date.year == int.parse(chooseTime))
            .toList();
      }

      return _transactionList;
    }
    // TRƯỜNG HỢP "ALL"
    else if (choosedTimeRange == 6) {
      return _transactionList;
    }
    // TRƯỜNG HỢP "CUSTOM"
    else {
      // tách từ tab bar được list 2 giá trị
      // chooseTime[i] = ngày/tháng/năm
      var chooseTime = myTabs[_tabController.index].text.split(' - ');

      // mốc thời gian đầu
      DateTime head;
      // mốc thời gian cuối
      DateTime tail;

      // tách từng mốc thời gian ra
      // head/tail = mốc thời gian
      var headList = chooseTime[0].split('/');
      head = DateTime(int.parse(headList[2]), int.parse(headList[1]),
          int.parse(headList[0]));

      var tailList = chooseTime[1].split('/');
      tail = DateTime(int.parse(tailList[2]), int.parse(tailList[1]),
          int.parse(tailList[0]));

      // từ mốc thời gian lọc ra các transaction thỏa điều kiện
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
    // biến tương tác với databse
    final firestore = Provider.of<FirebaseFireStoreService>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Style.backgroundColor,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 70,
          leading: GestureDetector(
            onTap: () async {
              buildShowDialogSelectWallet(context, wallet.id);
            },
            child: Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  SuperIcon(
                    iconPath: wallet.iconID,
                    size: 25.0,
                  ),
                  Icon(Icons.arrow_drop_down,
                      color: Style.foregroundColor.withOpacity(0.54))
                ],
              ),
            ),
          ),
          title: Column(children: [
            Text(wallet.name,
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontSize: 10.0)),
            MoneySymbolFormatter(
              text: wallet.amount,
              currencyId: wallet.currencyID,
              textStyle: TextStyle(
                  fontFamily: Style.fontFamily,
                  color: Style.foregroundColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
            )
          ]),
          bottom: TabBar(
            labelStyle: TextStyle(
              fontFamily: Style.fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 13.0,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: Style.fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 13.0,
            ),
            unselectedLabelColor: Style.foregroundColor.withOpacity(0.54),
            labelColor: Style.foregroundColor,
            indicatorColor: Style.primaryColor,
            physics: AlwaysScrollableScrollPhysics(),
            isScrollable: true,
            indicatorWeight: 3.0,
            controller: _tabController,
            tabs: myTabs,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications,
                  color: Style.foregroundColor.withOpacity(0.54)),
              tooltip: 'Notify',
              onPressed: () {},
            ),
            PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded,
                    color: Style.foregroundColor.withOpacity(0.54)),
                padding: EdgeInsets.all(10.0),
                offset: Offset.fromDirection(40, 40),
                color: Style.foregroundColor,
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
                        isDismissible: false,
                        enableDrag: false,
                        context: context,
                        builder: (context) =>
                            SearchTransactionScreen(wallet: wallet));
                  } else if (value == 'change display') {
                    setState(() {
                      viewByCategory = !viewByCategory;
                    });
                  } else if (value == 'Adjust Balance') {
                    showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            AdjustBalanceScreen(wallet: wallet));
                  } else if (value == 'Select time range') {
                    handleSelectTimeRange(choosedTimeRange);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: 'Select time range',
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Style.backgroundColor),
                            SizedBox(width: 10.0),
                            Text(
                              'Select time range',
                              style: TextStyle(
                                color: Style.backgroundColor,
                                fontFamily: Style.fontFamily,
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
                            Icon(Icons.remove_red_eye,
                                color: Style.backgroundColor),
                            SizedBox(width: 10.0),
                            Text(
                              viewByCategory
                                  ? 'View by date'
                                  : 'View by category',
                              style: TextStyle(
                                color: Style.backgroundColor,
                                fontFamily: Style.fontFamily,
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
                                color: Style.backgroundColor),
                            SizedBox(width: 10.0),
                            Text(
                              'Adjust Balance',
                              style: TextStyle(
                                color: Style.backgroundColor,
                                fontFamily: Style.fontFamily,
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
                            Icon(Icons.search, color: Style.backgroundColor),
                            SizedBox(width: 10.0),
                            Text(
                              'Search for transaction',
                              style: TextStyle(
                                color: Style.backgroundColor,
                                fontFamily: Style.fontFamily,
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
            stream: firestore.transactionStream(wallet, 'full'),
            builder: (context, snapshot) {
              List<MyTransaction> transactionList = snapshot.data ?? [];

              // lọc danh sách dựa trên tab được chọn
              transactionList =
                  sortTransactionBasedOnTime(choosedTimeRange, transactionList);

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
              transactionList.sort((a, b) => b.date.compareTo(a.date));

              // trường hợp hiển thị category
              if (viewByCategory) {
                transactionList.forEach((element) {
                  // lấy các category trong transaction đã lọc
                  if (!categoryInChoosenTime.contains(element.category.name))
                    categoryInChoosenTime.add(element.category.name);
                  // tính toán đầu vào, đầu ra
                  if (element.category.type == 'expense' ||
                      element.category.name == 'Repayment' ||
                      element.category.name == 'Loan')
                    totalOutCome += element.amount;
                  else
                    totalInCome += element.amount;
                });

                total = totalInCome - totalOutCome;

                // lấy các transaction ra theo từng category
                categoryInChoosenTime.forEach((cate) {
                  final b = transactionList.where(
                      (element) => element.category.name.compareTo(cate) == 0);
                  transactionListSorted.add(b.toList());
                });
              }
              // trường hợp hiển thị theo date (tương tự)
              else {
                transactionList.forEach((element) {
                  if (!dateInChoosenTime.contains(element.date))
                    dateInChoosenTime.add(element.date);
                  if (element.category.type == 'expense' ||
                      element.category.name == 'Repayment' ||
                      element.category.name == 'Loan')
                    totalOutCome += element.amount;
                  else
                    totalInCome += element.amount;
                });

                total = totalInCome - totalOutCome;

                dateInChoosenTime.forEach((date) {
                  final b = transactionList
                      .where((element) => element.date.compareTo(date) == 0);
                  transactionListSorted.add(b.toList());
                });
              }

              return TabBarView(
                controller: _tabController,
                children: myTabs.map((tab) {
                  if (transactionListSorted.length > 0) {
                    return viewByCategory == true
                        ? buildDisplayTransactionByCategory(
                            transactionListSorted,
                            totalInCome,
                            totalOutCome,
                            total)
                        : buildDisplayTransactionByDate(transactionListSorted,
                            totalInCome, totalOutCome, total);
                  } else {
                    return Container(
                        color: Style.backgroundColor,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              color: Style.foregroundColor.withOpacity(0.12),
                              size: 100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'There are no transactions',
                              style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Style.foregroundColor.withOpacity(0.24),
                              ),
                            ),
                          ],
                        ));
                  }
                }).toList(),
              );
            }));
  }

  Container buildDisplayTransactionByCategory(
      List<List<MyTransaction>> transactionListSortByCategory,
      double totalInCome,
      double totalOutCome,
      double total) {
    return Container(
      color: Style.backgroundColor,
      child: ListView.builder(
          // controller: listScrollController,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: transactionListSortByCategory.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            // tính toán lượng amount trong 1 category
            transactionListSortByCategory[xIndex].forEach((element) {
              if (element.category.type == 'expense' ||
                  element.category.name == 'Repayment' ||
                  element.category.name == 'Loan') {
                totalAmountInDay -= element.amount;
              } else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(transactionListSortByCategory, totalInCome,
                          totalOutCome, total),
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
    return Container(
      color: Style.backgroundColor,
      child: ListView.builder(
          // controller: listScrollController,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            // tính toán lượng amount trong ngày
            transactionListSortByDate[xIndex].forEach((element) {
              if (element.category.type == 'expense' ||
                  element.category.name == 'Repayment' ||
                  element.category.name == 'Loan')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(transactionListSortByDate, totalInCome,
                          totalOutCome, total),
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
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ),
              top: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ))),
      child: StickyHeader(
        header: Container(
          color: Style.boxBackgroundColor,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: SuperIcon(
                    iconPath:
                        transListSortByCategory[xIndex][0].category.iconID,
                    size: 30.0,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Text(
                    transListSortByCategory[xIndex][0].category.name +
                        '\n' +
                        transListSortByCategory[xIndex].length.toString() +
                        ' transactions',
                    // 'hello',
                    style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Style.foregroundColor.withOpacity(0.54))),
              ),
              Expanded(
                child: MoneySymbolFormatter(
                  digit: totalAmountInDay >= 0 ? '+' : '',
                  text: totalAmountInDay,
                  currencyId: wallet.currencyID,
                  textAlign: TextAlign.end,
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: Style.foregroundColor,
                  ),
                ),
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
                onTap: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                          childCurrent: this.widget,
                          child: TransactionDetail(
                            currentTransaction: transListSortByCategory[xIndex]
                                [yIndex],
                            wallet: widget.currentWallet,
                          ),
                          type: PageTransitionType.rightToLeft));
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Text(
                            DateFormat("dd").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 30.0,
                                color: Style.foregroundColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                            DateFormat("MMMM yyyy, EEEE").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Style.foregroundColor,
                            )),
                      ),
                      Expanded(
                        child: transListSortByCategory[xIndex][yIndex]
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
                                    'Debt Collection'
                            ? MoneySymbolFormatter(
                                text: transListSortByCategory[xIndex][yIndex]
                                    .amount,
                                currencyId: wallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Style.incomeColor2),
                              )
                            : MoneySymbolFormatter(
                                text: transListSortByCategory[xIndex][yIndex]
                                    .amount,
                                currencyId: wallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Style.expenseColor),
                                //digit: '-',
                              ),
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
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ),
              top: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ))),
      child: StickyHeader(
        header: Container(
          color: Style.boxBackgroundColor,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                    DateFormat("dd")
                        .format(transListSortByDate[xIndex][0].date),
                    style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 30.0,
                        color: Style.foregroundColor)),
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
                    style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Style.foregroundColor.withOpacity(0.54))),
              ),
              Expanded(
                child: MoneySymbolFormatter(
                  digit: totalAmountInDay >= 0 ? '+' : '',
                  text: totalAmountInDay,
                  currencyId: wallet.currencyID,
                  textAlign: TextAlign.end,
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: Style.foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        content: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transListSortByDate[xIndex].length,
            itemBuilder: (context, yIndex) {
              String _eventIcon =
                  (transListSortByDate[xIndex][yIndex].eventID == "" ||
                          transListSortByDate[xIndex][yIndex].eventID == null)
                      ? ''
                      : '🌴';
              String _note = transListSortByDate[xIndex][yIndex].note;
              String _contact =
                  transListSortByDate[xIndex][yIndex].contact ?? 'someone';
              String _subTitle;
              if (transListSortByDate[xIndex][yIndex].category.name == 'Debt') {
                _subTitle = '$_eventIcon from ';
              } else if (transListSortByDate[xIndex][yIndex].category.name ==
                  'Loan') {
                _subTitle = '$_eventIcon to ';
              } else {
                _subTitle = '$_eventIcon ';
              }

              String _digit =
                  transListSortByDate[xIndex][yIndex].category.type ==
                              'income' ||
                          transListSortByDate[xIndex][yIndex].category.name ==
                              'Debt' ||
                          transListSortByDate[xIndex][yIndex].category.name ==
                              'Debt Collection'
                      ? '+'
                      : '-';

              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            currentTransaction: transListSortByDate[xIndex]
                                [yIndex],
                            wallet: widget.currentWallet,
                          ),
                          type: PageTransitionType.rightToLeft));
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: SuperIcon(
                          iconPath: transListSortByDate[xIndex][yIndex]
                              .category
                              .iconID,
                          size: 35,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  transListSortByDate[xIndex][yIndex]
                                      .category
                                      .name,
                                  style: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                    color: Style.foregroundColor,
                                  )),
                              Text(
                                _note.length >= 20
                                    ? _note.substring(0, 20) + '...'
                                    : _note,
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color:
                                      Style.foregroundColor.withOpacity(0.54),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MoneySymbolFormatter(
                            text: transListSortByDate[xIndex][yIndex].amount,
                            currencyId: wallet.currencyID,
                            textAlign: TextAlign.end,
                            textStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: _digit == '+'
                                    ? Style.incomeColor2
                                    : Style.expenseColor),
                          ),
                          if (_subTitle != null && _subTitle != '')
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: _subTitle,
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color:
                                      Style.foregroundColor.withOpacity(0.54),
                                ),
                              ),
                              if (transListSortByDate[xIndex][yIndex]
                                          .category
                                          .name ==
                                      'Debt' ||
                                  transListSortByDate[xIndex][yIndex]
                                          .category
                                          .name ==
                                      'Loan')
                                TextSpan(
                                  text: _contact,
                                  style: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Style.foregroundColor,
                                  ),
                                )
                            ])),
                        ],
                      )),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  StickyHeader buildHeader(List<List<MyTransaction>> transListSortByDate,
      double totalInCome, double totalOutCome, double total) {
    return StickyHeader(
      header: SizedBox(height: 0),
      content: Container(
          decoration: BoxDecoration(
              color: Style.boxBackgroundColor,
              border: Border(
                  bottom: BorderSide(
                color: Style.backgroundColor,
                width: 1.0,
              ))),
          padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Inflow',
                      style: TextStyle(
                        color: Style.foregroundColor.withOpacity(0.54),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: Style.fontFamily,
                      )),
                  MoneySymbolFormatter(
                    text: totalInCome,
                    currencyId: wallet.currencyID,
                    textStyle: TextStyle(
                      color: Style.foregroundColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: Style.fontFamily,
                    ),
                    digit: '+',
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Outflow',
                        style: TextStyle(
                          color: Style.foregroundColor.withOpacity(0.54),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: Style.fontFamily,
                        )),
                    MoneySymbolFormatter(
                      text: totalOutCome,
                      currencyId: wallet.currencyID,
                      textStyle: TextStyle(
                        color: Style.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Style.fontFamily,
                      ),
                      digit: '-',
                    ),
                  ]),
            ),
            Divider(
              //height: 20,
              thickness: 1,
              color: Style.foregroundColor.withOpacity(0.12),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    MoneySymbolFormatter(
                      digit: total >= 0 ? '+' : '',
                      text: total,
                      currencyId: wallet.currencyID,
                      textStyle: TextStyle(
                        color: Style.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: Style.fontFamily,
                      ),
                    ),
                  ]),
            ),
            TextButton(
              onPressed: () {
                // tính toán mốc thời gian bắt đầu, kết thúc với trường hợp != "ALL"
                if (choosedTimeRange < 6) {
                  if (transListSortByDate[0][0].date.year <
                          beginDate[19].year ||
                      (transListSortByDate[0][0].date.year ==
                              beginDate[19].year &&
                          transListSortByDate[0][0].date.month <
                              beginDate[19].month) ||
                      (transListSortByDate[0][0].date.year ==
                              beginDate[19].year &&
                          transListSortByDate[0][0].date.month ==
                              beginDate[19].month &&
                          transListSortByDate[0][0].date.day <=
                              beginDate[19].day)) {
                    endDate.add(DateTime(beginDate[19].year,
                        beginDate[19].month, beginDate[19].day + 6));
                  } else
                    endDate.add(transListSortByDate[0][0].date);
                } else if (choosedTimeRange == 6) {
                  endDate.clear();
                  endDate.add(transListSortByDate[0][0].date);
                  beginDate.clear();
                  beginDate.add(
                      transListSortByDate[transListSortByDate.length - 1][0]
                          .date);
                }
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ReportForThisPeriodScreen(
                      currentWallet: wallet,
                      beginDate: beginDate[_tabController.index],
                      endDate: endDate[_tabController.index],
                    )));
              },
              child: Text(
                'View report for this period',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2cb84b)),
              ),
            )
          ])),
    );
  }

  void buildShowDialogSelectWallet(BuildContext context, id) async {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Style.boxBackgroundColor,
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();
}
