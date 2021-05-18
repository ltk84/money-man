import 'package:flutter/material.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

class IconPicker extends StatefulWidget {
  const IconPicker({Key key}) : super(key: key);

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  List<String> listIconURLs = [];

  @override
  Widget build(BuildContext context) {
    print("build 1");
    return FutureBuilder(
      future: getListIcon(),
      builder: (context, snapshot) {
        print(snapshot.connectionState.toString());
        print(listIconURLs.length.toString());
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leadingWidth: 70.0,
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                leading: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.transparent,
                    )
                ),
                title: Text('Icon Picker',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0)
                ),
              ),
              body: Container(
                color: Colors.black26,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemCount: listIconURLs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SuperIcon(
                      listIconURLs[index],
                      size: 20.0,
                    );
                  }
                ),
              )
          );
        }
        else {
          return Center(child: Text('Loading'));
        }
      }
    );
  }

  Future<void> getListIcon() async {
    ListResult result =
    await FirebaseStorage.instance.ref().listAll();
    List<String> URLResult = [];
    // result.items.forEach((element) {
    //   var iconURL = getIcon(element);
    //   listIconURLs.add(iconURL);
    // });
    for (int i = 0; i < result.items.length; i++) {
      var iconURL = await result.items[i].getDownloadURL();
      URLResult.add(iconURL);
    }
    listIconURLs = URLResult;
  }

  Future<dynamic> getIcon(element) async {
    var iconURL = await element.getDownloadURL();
    return iconURL;
  }
}

// class MyIcon extends StatefulWidget {
//   final refIcon;
//   const MyIcon({Key key, @required this.refIcon}) : super(key: key);
//
//   @override
//   _MyIconState createState() => _MyIconState();
// }
//
// class _MyIconState extends State<MyIcon> {
//   String urlIconPath;
//
//   @override
//   Widget build(BuildContext context) {
//     print("build 2");
//     return FutureBuilder(
//       future: getIcon(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done){
//           return SuperIcon(
//             urlIconPath,
//             size: 30.0,
//           );
//         }
//         else {
//           return Container(
//               width: 30.0,
//               height: 30.0,
//               child: Center(
//                   child: Icon(Icons.error, color: Colors.red)
//               )
//           );
//         }
//       }
//     );
//   }
//
//   Future<void> getIcon() async {
//     var url = await widget.refIcon.getDownloadURL();
//     urlIconPath = url;
//   }
// }
