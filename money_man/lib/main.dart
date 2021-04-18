import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/shared_screens/error_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/screens/transaction_detail.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail_screen.dart';
import 'package:money_man/ui/widgets/wrapper.dart';
import 'package:money_man/ui/widgets/wrapper_builder.dart';
import 'package:provider/provider.dart';
import 'core/services/firebase_authentication_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
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
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(home: ErrorScreen());
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(home: LoadingScreen());
    }

    return MultiProvider(
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
      // child: MaterialApp(home: TransactionDetailScreen()),
    );
  }
}
