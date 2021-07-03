import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_man/ui/screens/shared_screens/error_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/widgets/wrapper.dart';
import 'package:money_man/ui/widgets/wrapper_builder.dart';
import 'package:provider/provider.dart';
import 'core/services/firebase_authentication_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppState>().restartApp();
  }

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  // Set giá trị mặc định cho  `initialized` và `error` thành false
  bool initialized = false;
  bool error = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  // hàm initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // đợi Firebase init và set `initialized` thành true
      await Firebase.initializeApp();
      setState(() {
        initialized = true;
      });
    } catch (e) {
      // Set `error` thành true if Firebase init lỗi
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // hiển thị màn hinh lỗi nếu init lỗi
    if (error) {
      return MaterialApp(
          debugShowCheckedModeBanner: false, home: ErrorScreen());
    }

    if (_connectionStatus == ConnectivityResult.none) {
      return MaterialApp(
          debugShowCheckedModeBanner: false, home: ErrorScreen());
    }

    // hiển thị màn hình loading trong lúc init chưa xong
    if (!initialized) {
      return MaterialApp(home: LoadingScreen());
    }

    return KeyedSubtree(
      key: key,
      child: MultiProvider(
        providers: [
          Provider(create: (_) {
            return FirebaseAuthService();
          }),
        ],
        child: WrapperBuilder(
          builder: (context, userSnapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SafeArea(
                child: Wrapper(
                  userSnapshot: userSnapshot,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
