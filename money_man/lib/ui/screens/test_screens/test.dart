import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TestIconFeature extends StatefulWidget {
  const TestIconFeature({Key key}) : super(key: key);

  @override
  _TestIconFeatureState createState() => _TestIconFeatureState();
}



class _TestIconFeatureState extends State<TestIconFeature> {
  String url = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadURLExample();
  }
  Future<void> downloadURLExample() async {
    var downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('/bank.svg')
        .getDownloadURL();
    setState(() {
      url = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return ListView(
      children: [
        Text('cc'),
        SuperIcon(
          url,
          size: 100.0,
        )
      ],
    );
  }
}
