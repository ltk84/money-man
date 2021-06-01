import 'package:flutter/material.dart';

import 'current_applied_budget.dart';

class Applied extends StatelessWidget {
  const Applied({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      color: Color(0xff1a1a1a),
      //child: MyBudgetTile(),
      child: Column(
        children: [MyTimeRange(), MyBudgetTile()],
      ),
    );
  }
}
