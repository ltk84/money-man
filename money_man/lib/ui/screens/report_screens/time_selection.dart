import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Time_Selection extends StatefulWidget{
  @override
  _Time_Selection createState() =>  _Time_Selection();
}
class  _Time_Selection extends State<Time_Selection>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0,100, 0, 0),
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Choose the time period '),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                  title: const Text('Day'),
                  value: timeDilation != 1.0,
                  onChanged: (bool value){
                    setState(() {
                      timeDilation = value?0:1;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today)
              ),
              CheckboxListTile(
                  title: const Text('Week'),
                  value: timeDilation != 1.0,
                  onChanged: (bool value){
                    setState(() {
                      timeDilation = value?0:1;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today)
              ),
              CheckboxListTile(
                  title: const Text('Month'),
                  value: timeDilation != 1.0,
                  onChanged: (bool value){
                    setState(() {
                      timeDilation = value?0:1;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today)
              ),
              CheckboxListTile(
                  title: const Text('Precious'),
                  value: timeDilation != 1.0,
                  onChanged: (bool value){
                    setState(() {
                      timeDilation = value?0:1;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today)
              ),
              CheckboxListTile(
                  title: const Text('Year'),
                  value: timeDilation != 1.0,
                  onChanged: (bool value){
                    setState(() {
                      timeDilation = value?0:1;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today)
              ),
              CheckboxListTile(
                  title: const Text('All'),
                  value: timeDilation != 1.0,
                  onChanged: (bool value){
                    setState(() {
                      timeDilation = value?0:1;
                    });
                  },
                  secondary: const Icon(Icons.calendar_today)
              ),
            ],
          ),
        ),
      ),
    );
  }
}