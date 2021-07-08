import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  // lấy thông tin từ stream để listen tới sự thay đổi của authentication
  Stream<User> get userStream {
    // listen để in ra terminal
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    // trả về stream
    return auth.authStateChanges();
  }

  // lấy user hiện tại
  User get currentUser => auth.currentUser;

  // đăng nhập ẩn danh
  Future signInAnonymously() async {
    try {
      final res = await auth.signInAnonymously();
      return res.user;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // đăng xuất
  Future signOut() async {
    try {
      // đăng xuất firebase
      await auth.signOut();

      // đăng xuất Google account nếu có
      await GoogleSignIn().signOut();

      // đăng xuất Facebook account nếu có
      await FacebookLogin().logOut();
    } catch (e) {
      return e;
    }
  }

  // đăng nhập với email và password
  Future signInWithEmailAndPassword(email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return 'login-success';
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      return error;
    } on PlatformException catch (e) {
      return e.code;
    } on NoSuchMethodError catch (e) {
      return e;
    }
  }

  // đăng ký với email và password
  Future signUpWithEmailAndPassword(email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'login-success';
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      return error;
    } on PlatformException catch (e) {
      return e.code;
    } on NoSuchMethodError catch (e) {
      return e;
    }
  }

  // đăng nhập với tài khoản Google
  Future signInWithGoogleAccount() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      return 'login-success';
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      return error;
    } on PlatformException catch (e) {
      return e.code;
    } on NoSuchMethodError catch (e) {
      return e;
    }
  }

  // lấy lại mật khẩu qua email
  Future resetPassword(email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  //Hàm kiểm tra password
  Future<bool> validatePassword(String password) async {
    try {
      // lấy thông tin user hiện tại
      var firebaseUser = auth.currentUser;
      // lấy credential email
      var authCredentials = EmailAuthProvider.credential(
          email: firebaseUser.email, password: password);
      // kiểm tra lại với password của user
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  // hàm update password
  Future<void> updatePassword(String password) async {
    var firebaseUser = auth.currentUser;
    firebaseUser.updatePassword(password);
  }

  // đăng nhập với account Facebook
  Future signInWithFacebookVer2() async {
    try {
      final facebookLogin = FacebookLogin();
      facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
      final result = await facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final credential =
              FacebookAuthProvider.credential(result.accessToken.token);
          await auth.signInWithCredential(credential);
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }

      return 'login-success';
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      return error;
    } on PlatformException catch (e) {
      return e.code;
    }
  }
}
