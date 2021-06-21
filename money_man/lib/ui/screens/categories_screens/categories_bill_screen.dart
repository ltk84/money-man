import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class CategoriesBillScreen extends StatefulWidget {
  @override
  _CategoriesBillScreenState createState() =>
      _CategoriesBillScreenState();
}

class _CategoriesBillScreenState
    extends State<CategoriesBillScreen> with TickerProviderStateMixin {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

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
        backgroundColor: Style.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 250.0,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Style.foregroundColor),
                Hero(
                    tag: 'alo',
                    child: Text('More',
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontFamily: Style.fontFamily,
                            fontSize: 17.0))),
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
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 17.0))),
        ),
        body: StreamBuilder<List<MyCategory>>(
            stream: _firestore.categoryStream,
            builder: (context, snapshot) {
              final _listCategories = snapshot.data ?? [];
              final _selectCateTab = _listCategories
                  .where((element) =>
              element.type ==
                  'expense')
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
                              fontWeight: FontWeight.w700,
                              fontFamily: Style.fontFamily)),
                      onTap: () {
                        Navigator.pop(context, _selectCateTab[index]);
                      },
                    );
                  });
            })
      );
  }
}
