import 'package:flutter/cupertino.dart';
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
        body: FutureBuilder(
          future: getListIcon(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.black26,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                    ),
                    itemCount: listIconURLs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Widget icon = SuperIcon(
                        listIconURLs[index],
                        size: 20.0,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(icon);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: icon
                        ),
                      );
                    }
                ),
              );
            }
            else {
              return Center(child: Text('Loading'));
            }
          }
        )
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