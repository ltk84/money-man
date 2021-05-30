import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  String uid;
  FirebaseStorageService({this.uid});

  // Generic file upload for any path and contentType
  // Future<String> upload(
  //     {@required String uid,
  //     @required File file,
  //     @required String path,
  //     @required String contentType}) async {
  //   print('upload to: $path');
  //   final storageRef = storage.ref().child(path);
  //   final uploadTask =
  //       storageRef.putFile(file, SettableMetadata(contentType: contentType));
  //   final snapshot = await uploadTask;

  //   final downloadUrl = await snapshot.ref.getDownloadURL();
  //   //print(downloadUrl);
  //   return downloadUrl;
  // }

  // Upload an avatar from file
  // Future<String> uploadAvatar({@required File file, String playerID}) async =>
  //     await upload(
  //         uid: this.uid,
  //         file: file,
  //         path: FirestorePath.avatar(uid) + '/$playerID/avatar.png',
  //         contentType: 'img/png');
}
