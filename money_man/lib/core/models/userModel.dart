import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyUser {
  User userInfo;
  bool isEnable;
  MyUser({
    @required this.userInfo,
    @required this.isEnable,
  });
}
