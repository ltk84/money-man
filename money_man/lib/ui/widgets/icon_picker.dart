import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/superIconModel.dart';

class IconPicker extends StatefulWidget {
  const IconPicker({Key key}) : super(key: key);

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  List<String> listIcons = [];

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
            topRight: Radius.circular(20.0)
          )
        ),
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
            fontSize: 16.0
          )
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
                itemCount: listIcons.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(listIcons[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: SuperIcon(
                        iconPath: listIcons[index],
                        size: 20.0,
                      )
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

  Future getListIcon() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final iconPaths = manifestMap.keys
      .where((String key) => key.contains('icons/'))
      .where((String key) => key.contains('.svg'))
      .toList();
    listIcons = iconPaths;
  }
}