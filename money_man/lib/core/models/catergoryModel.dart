import 'package:flutter/material.dart';

class Catergory {
  String id;
  String name;
  String type;
  String iconID;
  Catergory({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.iconID,
  });

  factory Catergory.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return Catergory(
        id: data['id'],
        name: data['name'],
        type: data['type'],
        iconID: data['iconID']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type, 'iconID': iconID};
  }
}
