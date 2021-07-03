import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  // widget cần hiển thị
  final Widget child;
  // xem xét widget có cần mở rộng hay không ('true' => có, 'false' => không)
  final bool expand;

  //Hàm khỏi tạo class
  ExpandableWidget({this.expand = false, this.child});

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> with SingleTickerProviderStateMixin {

  //Tạo controller animation cho animation
  AnimationController expandController;
  //Tạo animation
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  //Setting up the animation controller
  void _runExpandCheck() {
    if(widget.expand) {
      expandController.forward();
    }
    else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: animation,
        child: widget.child
    );
  }
}
