import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class CategoriesTransactionScreen extends StatefulWidget {
  @override
  _CategoriesTransactionScreenState createState() =>
      _CategoriesTransactionScreenState();
}

class _CategoriesTransactionScreenState
    extends State<CategoriesTransactionScreen> {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  //
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          leadingWidth: 250.0,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white),
                Hero(
                    tag: 'alo',
                    child: Text('More',
                        style: Theme.of(context).textTheme.headline6)),
              ],
            ),
          ),
          //),
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
          title: AnimatedOpacity(
              opacity: reachTop == 1 ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Text(
                  ''
                  'Categories',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montseratt',
                      fontSize: 17.0)))),
      body: StreamBuilder<List<MyCategory>>(
          stream: _firestore.categoryStream,
          builder: (context, snapshot) {
            final _listCategories = snapshot.data ?? [];
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _controller,
                itemCount: _listCategories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading:
                        Icon(Icons.ac_unit_sharp, color: Colors.yellow[700]),
                    title: Text(_listCategories[index].name,
                        style: Theme.of(context).textTheme.subtitle1),
                    onTap: () {
                      Navigator.pop(context, _listCategories[index]);
                    },
                  );
                });
          }),
    );
  }
}
