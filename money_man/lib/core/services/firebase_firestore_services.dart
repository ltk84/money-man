import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/walletModel.dart';
import '../models/transactionModel.dart';

class FirebaseFireStoreService {
  final String uid;

  FirebaseFireStoreService({@required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // update id của wallet đang được chọn
  void updateSelectedWalletID(String walletID) async {
    Wallet w;
    await users
        .doc(uid)
        .collection('wallets')
        .doc(walletID)
        .get()
        .then((value) {
      w = Wallet.fromMap(value.data());
    });

    await users
        .doc(uid)
        .update(w.toMap())
        .then((value) => print('updated!'))
        .catchError((onError) => print(onError));
  }

  // stream wallet hiện tại
  Stream<Wallet> get currentWallet {
    return users
        .doc(uid)
        .snapshots()
        .map((event) => Wallet.fromMap(event.data()));
  }

  // lấy id của wallet đang được chọn
  // get selectedWalletID async {
  //   try {
  //     String ref = "";
  //     await users.doc(uid).get().then((value) async {
  //       ref = await value.data()['selectedWalletID'];
  //     });
  //     return ref;
  //   } on StateError catch (e) {
  //     print('Field not exist');
  //     return null;
  //   }
  // }

  //add transaction
  Future addTransaction(Wallet wallet, MyTransaction transaction) async {
    final transactionRef = users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .doc();
    transaction.id = transactionRef.id;
    return await transactionRef
        .set(transaction.toMap())
        .then((value) => print('player added!'))
        .catchError((error) => print(error));
  }

  // add wallet test chưa có tham số
  Future addWallet() async {
    DocumentReference walletRef = users.doc(uid).collection('wallets').doc();
    // final id = walletRef.parent;
    Wallet wallet = Wallet(
        id: walletRef.id,
        name: 'test1',
        amount: 100,
        currencyID: 'a',
        iconID: 'a');

    return await walletRef
        .set(wallet.toMap())
        .then((value) => print('wallet added!'))
        .catchError((error) => print(error));
  }

  // convert from snapshot
  List<Wallet> _walletFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Wallet.fromMap(e.data())).toList();
  }

  // get stream wallet
  Stream<List<Wallet>> get streamWallet {
    return users
        .doc(uid)
        .collection('wallets')
        .snapshots()
        .map(_walletFromSnapshot);
  }

  // // edit player
  // Future editPlayer(Player player) async {
  //   return await userCollections
  //       .doc(uid)
  //       .set({
  //         'name': player.name,
  //         'age': player.age,
  //         'club': player.club,
  //         'position': player.position,
  //       })
  //       .then((value) => print('player edited!'))
  //       .catchError((error) => print(error));
  // }

  // List<Player> _playerFormSnapShot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     print(uid);
  //     return Player(
  //       id: doc.data()['id'] ?? '',
  //       name: doc.data()['name'] ?? '',
  //       age: doc.data()['age'] ?? '',
  //       club: doc.data()['club'] ?? '',
  //       position: doc.data()['position'] ?? '',
  //       downloadURL: doc.data()['downloadURL'] ?? '',
  //     );
  //   }).toList();
  // }

  // //delete player
  // Future<void> deletePlayer(String playerID) async {
  //   return await userCollections
  //       .doc(uid)
  //       .collection('players')
  //       .doc(playerID)
  //       .delete()
  //       .then((value) => print('player deleted'))
  //       .catchError((error) => print(error));
  // }

  // // fetch data in stream
  // Stream<List<Player>> get players {
  //   return userCollections
  //       .doc(uid)
  //       .collection('players')
  //       .snapshots()
  //       .map(_playerFormSnapShot);
  // }

  // // set the avatar download url
  // Future setAvatarReferenc(
  //     {@required AvatarReference ava, @required String playerID}) async {
  //   final ref = userCollections.doc(uid).collection('players').doc(playerID);
  //   await ref
  //       .update({'downloadURL': ava.downloadUrl})
  //       .then((value) => print('upadate sucess'))
  //       .catchError((onError) => print(onError));
  // }

  // // read the current avatar download url
  // Stream<AvatarReference> avaRefStream({String playerID}) {
  //   return userCollections
  //       .doc(uid)
  //       .collection('players')
  //       .doc(playerID)
  //       .snapshots()
  //       .map((snapshot) => AvatarReference.fromMap(snapshot.data()));
  // }
}
