import 'package:flutter/material.dart';

class MyCategory {
  String id;
  String name;
  String type;
  String iconID;
  MyCategory({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.iconID,
  });

  factory MyCategory.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return MyCategory(
        id: data['id'],
        name: data['name'],
        type: data['type'],
        iconID: data['iconID']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type, 'iconID': iconID};
  }
}
