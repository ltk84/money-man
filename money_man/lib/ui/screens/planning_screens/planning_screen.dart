import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bills_main_screen.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/budget_home.dart';
import 'package:money_man/ui/screens/planning_screens/recurring_transaction_screens/recurring_transaction_main_screen.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/event_home.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';

class PlanningScreen extends StatefulWidget {
  final Wallet currentWallet;

  PlanningScreen({Key key, this.currentWallet}) : super(key: key);

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  // Biến để lưu ví khi lấy từ tham số.
  Wallet wallet;

  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  final double fontSizeText = 60;
  int reachTop = 0;
  int reachAppBar = 0;

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    } else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >= fontSizeText - 5) {
      setState(() {
        reachTop = 1;
      });
    } else {
      setState(() {
        reachTop = 0;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(scrollListener);
    super.initState();

    // Lấy ví từ tham số.
    wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant PlanningScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Lấy ví từ tham số.
    wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: AnimatedOpacity(
              opacity: reachAppBar == 1 ? 1 : 0,
              duration: Duration(milliseconds: 0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: reachTop == 1 ? 25 : 500,
                    sigmaY: 25,
                    tileMode: TileMode.values[0]),
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds:
                          reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                  color: Colors.grey[
                          reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900]
                      .withOpacity(0.2),
                ),
              ),
            ),
          ),
          title: AnimatedOpacity(
              opacity: reachTop == 1 ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Text('Planning',
                  style: TextStyle(
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0))),
        ),
        body: Container(
          child: ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: _controller,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0.0, 15, 0, 10.0),
                child: reachTop == 0
                    ? Hero(
                        tag: 'planningScreen',
                        child: Text('Planning',
                            style: TextStyle(
                              fontSize: 35,
                              color: Style.foregroundColor,
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                            )))
                    : Text('',
                        style: TextStyle(
                          fontSize: 35,
                          color: Style.foregroundColor,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w700,
                        )),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xffe0f0f8);
                        return Color(0xff314656);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xff314656);
                        return Color(0xffe0f0f8);
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: BudgetScreen(
                            crrWallet: wallet,
                          ),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              SuperIcon(
                                iconPath: 'assets/images/budget.svg',
                                size: 45,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('BUDGET',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Style.fontFamily,
                                      fontSize: 15.0)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 6,
                            child: Text(
                                "Build your own financial plan to balance your income and expenses.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Style.fontFamily,
                                    fontSize: 16.0))),
                      ],
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xffffffff);
                        return Color(0xfffc745c);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xfffc745c);
                        return Color(0xffffffff);
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: EventScreen(
                            currentWallet: wallet,
                          ),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              SuperIcon(
                                iconPath: 'assets/images/event.svg',
                                size: 45,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('EVENTS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Style.fontFamily,
                                      fontSize: 15.0)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 6,
                            child: Text(
                                "Keep track of your spending during an event.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Style.fontFamily,
                                    fontSize: 16.0))),
                      ],
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xfff3543c);
                        return Color(0xfff7dfbc);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xfff7dfbc);
                        return Color(0xfff3543c);
                      },
                    ),
                  ),
                  onPressed: () {
                    print('planing' + widget.currentWallet.id);
                    print('planing' + wallet.id);
                    Navigator.push(
                      context,
                      PageTransition(
                          child: BillsMainScreen(
                            currentWallet: wallet,
                          ),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              SuperIcon(
                                iconPath: 'assets/images/bill.svg',
                                size: 45,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('BILLS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Style.fontFamily,
                                      fontSize: 15.0)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 6,
                            child: Text(
                                "Monitor your repetitive bills such as electricity, rent, etc.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Style.fontFamily,
                                    fontSize: 16.0))),
                      ],
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xff17174e);
                        return Color(0xfffbe383);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xfffbe383);
                        return Color(0xff17174e);
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: RecurringTransactionMainScreen(wallet: wallet),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              SuperIcon(
                                iconPath: 'assets/images/recurring.svg',
                                size: 45,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('RECURRING',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: Style.fontFamily,
                                      fontSize: 15.0)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 6,
                            child: Text(
                                "Add transactions automatically in the future.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: Style.fontFamily,
                                    fontSize: 16.0))),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
