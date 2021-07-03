import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // hiển thị màn hinh lỗi nếu init lỗi
    if (error) {
      return MaterialApp(home: ErrorScreen());
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
