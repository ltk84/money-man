import 'package:flutter/material.dart';

class Icon {
  String id;
  String link;
  Icon({
    @required this.id,
    @required this.link,
  });

  factory Icon.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return Icon(id: data['id'], link: data['link']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'link': link};
  }
}
