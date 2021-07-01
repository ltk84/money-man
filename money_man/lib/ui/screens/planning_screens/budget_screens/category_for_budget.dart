import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

// Này là màn hình chọn category cho budget, giống với các màn hình chọn category khác, chỉ bỏ đi phần Debt & Loan
class CategoriesBudgetScreen extends StatefulWidget {
  final String walletId;

  const CategoriesBudgetScreen({Key key, this.walletId}) : super(key: key);

  @override
  _CategoriesBudgetScreenState createState() => _CategoriesBudgetScreenState();
}

class _CategoriesBudgetScreenState extends State<CategoriesBudgetScreen>
    with TickerProviderStateMixin {
  // list tab category
  final List<Tab> categoryTypeTab = [
    Tab(
      text: 'EXPENSE',
    ),
    Tab(
      text: 'INCOME',
    ),
  ];

  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  // Tab controller cho tab bar
  TabController _tabController;

  // Text title = Text('My Account', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));
  // Text emptyTitle = Text('', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
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
    _controller.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Style.backgroundColor,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 250.0,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Style.backIcon, color: Style.foregroundColor),
              ],
            ),
          ),
          //),
          centerTitle: true,
          backgroundColor: Style.appBarColor,
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
                  //child: Container(
                  //color: Colors.transparent,
                  color: Colors.grey[
                          reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900]
                      .withOpacity(0.2),
                  //),
                ),
              ),
            ),
          ),
          title: Text('Categories',
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: 'Montseratt',
                  fontSize: 20.0)),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey[500],
            labelColor: Style.foregroundColor,
            indicatorColor: Colors.yellow[700],
            physics: NeverScrollableScrollPhysics(),
            isScrollable: true,
            indicatorWeight: 3.0,
            controller: _tabController,
            tabs: categoryTypeTab,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: categoryTypeTab.map((e) {
            return StreamBuilder<List<MyCategory>>(
                stream: _firestore.categoryStream,
                builder: (context, snapshot) {
                  final _listCategories = snapshot.data ?? [];
                  final _selectCateTab = _listCategories
                      .where((element) =>
                          element.type ==
                          categoryTypeTab[_tabController.index]
                              .text
                              .toLowerCase())
                      .toList();
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      itemCount: _selectCateTab.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: SuperIcon(
                              iconPath: _selectCateTab[index].iconID,
                              size: 35.0),
                          title: Text(_selectCateTab[index].name,
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600)),
                          onTap: () {
                            Navigator.pop(context, _selectCateTab[index]);
                          },
                        );
                      });
                });
          }).toList(),
        ),
      ),
    );
  }
}
