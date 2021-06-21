import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/ui/style.dart';

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
        backgroundColor: Style.backgroundColor1,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.boxBackgroundColor,
          leading: CloseButton(
            color: Style.foregroundColor
          ),
          title: Text('Icon Picker',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,
              )),
        ),
        body: FutureBuilder(
            future: getListIcon(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: Style.backgroundColor1,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              )),
                        );
                      }),
                );
              } else {
                return Container(
                    color: Style.backgroundColor,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty,
                          color: Style.foregroundColor.withOpacity(0.12),
                          size: 100,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          'Loading',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Style.foregroundColor.withOpacity(0.24),
                          ),
                        ),
                      ],
                    )
                );
              }
            }));
  }

  Future getListIcon() async {
    // >> To get paths you need these 2 lines
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final iconPaths = manifestMap.keys
        .where((String key) => key.contains('icons/'))
        .where((String key) => key.contains('.svg'))
        .toList();
    listIcons = iconPaths;
  }
}
