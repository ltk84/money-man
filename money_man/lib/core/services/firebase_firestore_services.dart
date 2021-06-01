import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';

class FirebaseFireStoreService {
  final String uid;

  FirebaseFireStoreService({@required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  // WALLET START//

  // update id của wallet đang được chọn
  Future<String> updateSelectedWallet(String walletID) async {
    // lấy wallet thông qua id
    Wallet wallet;
    await users
        .doc(uid)
        .collection('wallets')
        .doc(walletID)
        .get()
        .then((value) {
      print(walletID);
      wallet = Wallet.fromMap(value.data());
    }).catchError((error) => print(error));

    // update ví đang được chọn lên database
    await users
        .doc(uid)
        .update({'currentWallet': wallet.toMap()})
        .then((value) => print('updated!'))
        .catchError((onError) {
          print(onError);
          return onError.toString();
        });

    return wallet.id;
  }

  // add first wallet
  Future addFirstWallet(Wallet wallet) async {
    double amount = wallet.amount;
    wallet.amount = 0;
    // lấy doc reference để auto generate id của doc
    DocumentReference docRef = users.doc(uid).collection('wallets').doc();
    wallet.id = docRef.id;

    // thêm ví vào collection wallets và set wallet đang được chọn
    await docRef
        .set(wallet.toMap())
        .then((value) => print('add wallet to collection wallets'))
        .catchError((error) => print(error.toString()));

    await users
        .doc(uid)
        .set({'currentWallet': wallet.toMap()})
        .then((value) => print('set selected wallet'))
        .catchError((error) => print(error));

    MyCategory category;
    await categories.where('name', isEqualTo: 'Other Income').get().then(
        (value) => category = MyCategory.fromMap(value.docs.first.data()));

    MyTransaction trans = MyTransaction(
        id: 'id',
        amount: amount,
        date: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        currencyID: wallet.currencyID,
        category: category,
        note: 'Initial Balance');
    await addTransaction(wallet, trans);
  }

  // stream của wallet hiện tại đang được chọn
  Stream<Wallet> get currentWallet {
    return users.doc(uid).snapshots().map((event) {
      return Wallet.fromMap(event.get('currentWallet'));
    });
  }

  // add wallet
  Future addWallet(Wallet wallet) async {
    DocumentReference walletRef = users.doc(uid).collection('wallets').doc();
    wallet.id = walletRef.id;
    MyCategory category;

    double amount = wallet.amount;
    wallet.amount = 0;

    await walletRef
        .set(wallet.toMap())
        .then((value) => print('wallet added!'))
        .catchError((error) {
      print(error);
      return error.toString();
    });

    await categories.where('name', isEqualTo: 'Other Income').get().then(
        (value) => category = MyCategory.fromMap(value.docs.first.data()));

    MyTransaction trans = MyTransaction(
        id: 'id',
        amount: amount,
        date: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        currencyID: wallet.currencyID,
        category: category,
        note: 'Adjust Balance');
    await addTransaction(wallet, trans);

    return wallet.id;
  }

  // edit wallet
  Future updateWallet(Wallet wallet) async {
    await users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .update(wallet.toMap())
        .then((value) => print('Edit success!'))
        .catchError((error) {
      print(error);
      return error.toString();
    });
  }

  // detele wallet
  Future deleteWallet(String walletID) async {
    var length = 0;
    CollectionReference wallets = users.doc(uid).collection('wallets');
    await wallets.get().then((value) {
      length = value.size;
    }).catchError((error) => print(error));
    // trường họp chỉ có 1 ví
    if (length == 1) return 'only 1 wallet';

    // trường hợp có nhiều hơn 1 ví
    // xóa ví
    await users
        .doc(uid)
        .collection('wallets')
        .doc(walletID)
        .delete()
        .then((value) => print('deleted success!'))
        .catchError((error) {
      print(error);
      return error.toString();
    });

    // thiết lập lại ví đang được chọn
    Wallet firstWallet;
    await users.doc(uid).collection('wallets').get().then((value) async {
      firstWallet = Wallet.fromMap(value.docs.first.data());
      await updateSelectedWallet(firstWallet.id);
    });
    return firstWallet.id;
  }

  // convert from snapshot
  List<Wallet> _walletFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Wallet.fromMap(e.data())).toList();
  }

  // get stream wallet
  Stream<List<Wallet>> get walletStream {
    return users
        .doc(uid)
        .collection('wallets')
        .snapshots()
        .map(_walletFromSnapshot);
  }

  // get wallet by id
  Future<Wallet> getWalletByID(String id) async {
    return await users
        .doc(uid)
        .collection('wallets')
        .doc(id)
        .get()
        .then((value) => Wallet.fromMap(value.data()));
  }

  // adjust wallet's balance
  Future adjustBalance(Wallet wallet, double amount) async {
    double transactionAmount;
    MyCategory category;

    transactionAmount = amount - wallet.amount;
    if (transactionAmount > 0)
      await categories.where('name', isEqualTo: 'Other Income').get().then(
          (value) => category = MyCategory.fromMap(value.docs.first.data()));
    else {
      await categories.where('name', isEqualTo: 'Other Expense').get().then(
          (value) => category = MyCategory.fromMap(value.docs.first.data()));
      transactionAmount = -transactionAmount;
    }

    MyTransaction trans = MyTransaction(
        id: 'id',
        amount: transactionAmount,
        date: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        currencyID: wallet.currencyID,
        category: category,
        note: 'Adjust Balance');
    await addTransaction(wallet, trans);
  }

  // WALLET END//

  // TRANSACTION START//

  // add transaction
  Future addTransaction(Wallet wallet, MyTransaction transaction) async {
    // lấy reference của list transaction để lấy auto-generate id
    final transactionRef = users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .doc();

    // gán id cho transaction
    transaction.id = transactionRef.id;

    // thực hiện add transaction
    await transactionRef
        .set(transaction.toMap())
        .then((value) => print('transaction added!'))
        .catchError((error) => print(error));

    // update searchList để sau này dùng cho việc search transaction
    List<String> searchList = splitNumber(transaction.amount.toInt());
    await transactionRef
        .update({'amountSearch': FieldValue.arrayUnion(searchList)}).catchError(
            (error) => print(error));

    // Update amount của wallet
    if (transaction.category.type == 'expense')
      wallet.amount -= transaction.amount;
    else
      wallet.amount += transaction.amount;

    // udpate wallet trong list và wallet đang được chọn
    await updateWallet(wallet);
    await updateSelectedWallet(wallet.id);
  }

  List<String> splitNumber(int number) {
    String strNum = number.toString();
    List<String> list = [];
    String total = '';
    for (int i = 0; i < strNum.length; i++) {
      String char = strNum[i];
      total += char;
      list.add(total);
    }
    return list;
  }

  // stream đến transaction của wallet đang được chọn
  Stream<List<MyTransaction>> transactionStream(Wallet wallet, dynamic limit) {
    if (limit == 'full') {
      return users
          .doc(uid)
          .collection('wallets')
          .doc(wallet.id)
          .collection('transactions')
          .snapshots()
          .map(_transactionFromSnapshot);
    } else {
      return users
          .doc(uid)
          .collection('wallets')
          .doc(wallet.id)
          .collection('transactions')
          .limit(limit)
          .orderBy('date', descending: true)
          .snapshots()
          .map(_transactionFromSnapshot);
    }
  }

  // convert từ snapshot thành transaction
  List<MyTransaction> _transactionFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return MyTransaction.fromMap(e.data());
    }).toList();
  }

  // delete transaction by id
  Future deleteTransaction(MyTransaction transaction, Wallet wallet) async {
    await users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .doc(transaction.id)
        .delete()
        .then((value) => print('transaction deleted!'))
        .catchError((error) {
      print(error);
    });

    if (transaction.category.type == 'expense')
      wallet.amount += transaction.amount;
    else
      wallet.amount -= transaction.amount;

    await updateWallet(wallet);
    await updateSelectedWallet(wallet.id);
  }

  // update transaction
  Future updateTransaction(MyTransaction transaction, Wallet wallet) async {
    // Lấy reference đến collection transactions
    CollectionReference transactionRef = users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions');

    // Lấy transaction cũ
    MyTransaction oldTransaction;
    await transactionRef.doc(transaction.id).get().then((value) {
      oldTransaction = MyTransaction.fromMap(value.data());
    });

    // Tính toán để lấy lại amount cũ của ví
    if (oldTransaction.category.type == 'expense')
      wallet.amount += oldTransaction.amount;
    else
      wallet.amount -= oldTransaction.amount;

    // Tính toán lấy amount mới của ví
    if (transaction.category.type == 'expense')
      wallet.amount -= transaction.amount;
    else
      wallet.amount += transaction.amount;

    // update transaction
    await transactionRef.doc(transaction.id).update(transaction.toMap());

    // update searchList để sau này dùng cho việc search transaction
    List<String> searchList = splitNumber(transaction.amount.toInt());
    await transactionRef
        .doc(transaction.id)
        .update({'amountSearch': FieldValue.arrayUnion(searchList)});

    // update ví trong list và ví đang được chọn
    await updateWallet(wallet);
    await updateSelectedWallet(wallet.id);
  }

  // Query transaction by category
  Future<List<MyTransaction>> queryTransationByCategory(
      String searchPattern, Wallet wallet) async {
    double number = double.tryParse(searchPattern);
    List<MyTransaction> listTrans = [];

    // trường hợp search bằng số
    if (number != null) {
      int intNum = number.toInt();
      await users
          .doc(uid)
          .collection('wallets')
          .doc(wallet.id)
          .collection('transactions')
          .where('amountSearch', arrayContainsAny: [intNum.toString()])
          .get()
          .then((value) {
            if (value.docs.isNotEmpty) {
              value.docs.forEach((element) {
                MyTransaction trans = MyTransaction.fromMap(element.data());
                if (!listTrans.contains(trans)) listTrans.add(trans);
              });
            }
          });
    } else {
      // trường hợp tìm theo category
      searchPattern = searchPattern.toLowerCase();
      List<List<String>> cateName = [[]];
      int index = 0;

      // dựa trên searchPattern để tìm kiếm category thích hợp trong collection categories
      await categories
          .where('searchIndex', arrayContainsAny: [searchPattern])
          .get()
          .then((value) => value.docs.map((e) {
                MyCategory a = MyCategory.fromMap(e.data());
                // print(a.name);
                if (cateName[index].length == 10) {
                  cateName.add([]);
                  index++;
                }
                cateName[index].add(a.name);
              }).toList());

      // Dựa trên list categories ở trên để tìm kiếm các transaction thỏa điều kiện

      for (int i = 0; i < cateName.length; i++) {
        for (int j = 0; j < cateName[i].length; j++)
          await users
              .doc(uid)
              .collection('wallets')
              .doc(wallet.id)
              .collection('transactions')
              .where('category.name', isEqualTo: cateName[i][j])
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              value.docs.forEach((element) {
                MyTransaction trans = MyTransaction.fromMap(element.data());
                if (!listTrans.contains(trans)) listTrans.add(trans);
              });
            }
          });
      }
    }
    print(listTrans.length);
    return listTrans;
  }

  // TRANSACTION END//

  // CATERGORY START//

  // get stream list category
  Stream<List<MyCategory>> get categoryStream {
    return categories.snapshots().map(_categoryFromSnapshot);
  }

  // convert từ snapshot thành category
  List<MyCategory> _categoryFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return MyCategory.fromMap(e.data());
    }).toList();
  }

  // add instance cate
  void addCate() async {
    final cateRef = categories.doc();
    MyCategory cat = MyCategory(
        id: cateRef.id, name: '', type: 'expense', iconID: 'defaultID');
    await cateRef
        .set(cat.toMap())
        .then((value) => print('added!'))
        .catchError((error) => print(error));
  }

  // Lấy category bằng id
  Future<MyCategory> getCategoryByID(String id) async {
    return categories
        .doc(id)
        .get()
        .then((value) => MyCategory.fromMap(value.data()));
  }

  // CATERGORY END //

  // USER START //
  Stream<String> get userName {
    return users.doc(uid).snapshots().map(_userNameFromSnapshot);
  }

  String _userNameFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.get(FieldPath(['userName'])).toString();
  }
  // USER END //

  // BUDGET START //

  // add budget
  Future addBudget(Budget budget, Wallet wallet) async {
    // lấy reference đến collection budgets
    final budgetsRef = users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('budgets')
        .doc();

    // lấy auto id gán cho budget
    budget.id = budgetsRef.id;

    // khai báo biến spent (số tiền của các transaction thỏa yêu cầu của budget)
    double spent = 0;

    // dựa trên category để lấy các transaction thỏa yêu cầu => tính toán spent
    await users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .where('category.id', isEqualTo: budget.category.id)
        .get()
        .then((value) =>
            value.docs.map((e) => spent += e.get('amount')).toList());

    // gán spent cho budget
    budget.spent = spent;

    // thực hiện add budget
    await budgetsRef
        .set(budget.toMap())
        .then((value) => print('budget added!'))
        .catchError((error) => print(error));
  }

  // demo add
  // Future addBudget() async {
  //   MyCategory category = MyCategory(
  //       id: 'A6V8wN5GRMrWAthzx0YH',
  //       name: 'Education',
  //       type: 'expense',
  //       iconID: 'assets/icons/education.svg');

  //   Wallet wallet = Wallet(
  //       id: '6EYteq8rWqNJjJbJBJZZ',
  //       name: 'vi moi',
  //       amount: 1294495,
  //       currencyID: 'JPY',
  //       iconID: 'assets/icons/health.svg');

  //   double amount = 20000;
  //   DateTime now = DateTime.now();
  //   DateTime beginDate = DateTime(now.year, now.month, 1);
  //   DateTime endDate = DateTime(now.year, now.month, 30);

  //   final budgetsRef = users
  //       .doc(uid)
  //       .collection('wallets')
  //       .doc(wallet.id)
  //       .collection('budgets')
  //       .doc();

  //   double spent = 0;

  //   await users
  //       .doc(uid)
  //       .collection('wallets')
  //       .doc(wallet.id)
  //       .collection('transactions')
  //       .where('category.id', isEqualTo: category.id)
  //       .get()
  //       .then((value) =>
  //           value.docs.map((e) => spent += e.get('amount')).toList());

  //   Budget budget = Budget(
  //       id: budgetsRef.id,
  //       category: category,
  //       amount: amount,
  //       spent: spent,
  //       walletId: wallet.id,
  //       isFinished: false,
  //       beginDate: beginDate,
  //       endDate: endDate,
  //       isRepeat: false);

  //   await budgetsRef
  //       .set(budget.toMap())
  //       .then((value) => print('budget added!'))
  //       .catchError((error) => print(error));
  // }

  // Stream budget dùng để hiển thị list các budget đã có dựa trên wallet id
  // tìm chỗ thích hợp để đặt 1 streambuilder<List<Budget>> để lấy dữ liệu
  // khuyến khích đặt ở screen gốc (budget_home) để có sẵn dữ liệu rồi truyền vào các screen child sẽ dễ hơn
  Stream<List<Budget>> budgetStream(String walletId) {
    return users
        .doc(uid)
        .collection('wallets')
        .doc(walletId)
        .collection('budgets')
        .snapshots()
        .map(_budgetFromSnapshot);
  }

  // convert budget from snapshot (hàm này convert từ dữ liệu firebase thành budget)
  List<Budget> _budgetFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      print(e.data());
      return Budget.fromMap(e.data());
    }).toList();
  }

  // edit budget
  Future updateBudget(Budget budget, Wallet wallet) async {
    // khái báo spent vì khi user thay đổi thông tin budget thì có thể thay đổi category
    // nên spent sẽ có thể bị tính lại từ đầu
    double spent = 0;

    // lấy các transaction dựa trên category để tính toán spent
    await users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('transactions')
        .where('category.id', isEqualTo: budget.category.id)
        .get()
        .then((value) =>
            value.docs.map((e) => spent += e.get('amount')).toList());

    // gán spent cho budget
    budget.spent = spent;

    // thực hiện update budget
    await users
        .doc(uid)
        .collection('wallets')
        .doc(wallet.id)
        .collection('budgets')
        .doc(budget.id)
        .update(budget.toMap())
        .then((value) => print('budget updated!'))
        .catchError((error) => print(error));
  }

  // demo edit budget
  // Future updateBudget() async {
  //   MyCategory category = MyCategory(
  //       id: '1EAiphBEEQ1Eu7rAuRn5',
  //       name: 'Bills & Utilities',
  //       type: 'expense',
  //       iconID: 'assets/icons/bills.svg');

  //   Wallet wallet = Wallet(
  //       id: '6EYteq8rWqNJjJbJBJZZ',
  //       name: 'vi moi',
  //       amount: 1294495,
  //       currencyID: 'JPY',
  //       iconID: 'assets/icons/health.svg');

  //   DateTime now = DateTime.now();
  //   DateTime beginDate = DateTime(now.year, now.month, 1);
  //   DateTime endDate = DateTime(now.year, now.month, 30);

  //   Budget budget = Budget(
  //       id: 'YSqibmd5tQXRFhTXNQRN',
  //       category: category,
  //       amount: 40000,
  //       spent: 31200,
  //       walletId: wallet.id,
  //       isFinished: false,
  //       beginDate: beginDate,
  //       endDate: endDate,
  //       isRepeat: false);

  //   double spent = 0;

  //   await users
  //       .doc(uid)
  //       .collection('wallets')
  //       .doc(wallet.id)
  //       .collection('transactions')
  //       .where('category.id', isEqualTo: budget.category.id)
  //       .get()
  //       .then((value) =>
  //           value.docs.map((e) => spent += e.get('amount')).toList());

  //   budget.spent = spent;

  //   await users
  //       .doc(uid)
  //       .collection('wallets')
  //       .doc(wallet.id)
  //       .collection('budgets')
  //       .doc(budget.id)
  //       .update(budget.toMap())
  //       .then((value) => print('budget updated!'))
  //       .catchError((error) => print(error));
  // }

  // delete budget
  Future deleteBudget(String walletId, String budgetId) async {
    // thực hiện delete budget thôi
    await users
        .doc(uid)
        .collection('wallets')
        .doc(walletId)
        .collection('budgets')
        .doc(budgetId)
        .delete()
        .then((value) => print('budget deleted!'))
        .catchError((error) => print(error));
  }

  // demo add budget
  // Future addBudget() async {
  //   MyCategory category = MyCategory(
  //       id: 'A6V8wN5GRMrWAthzx0YH',
  //       name: 'Education',
  //       type: 'expense',
  //       iconID: 'assets/icons/education.svg');

  //   Wallet wallet = Wallet(
  //       id: '6EYteq8rWqNJjJbJBJZZ',
  //       name: 'vi moi',
  //       amount: 1294495,
  //       currencyID: 'JPY',
  //       iconID: 'assets/icons/health.svg');

  //   List<MyTransaction> transactionList = [];

  //   final budgetsRef = users
  //       .doc(uid)
  //       .collection('wallets')
  //       .doc(wallet.id)
  //       .collection('budgets')
  //       .doc();

  //   await users
  //       .doc(uid)
  //       .collection('wallets')
  //       .doc(wallet.id)
  //       .collection('transactions')
  //       .where('category.id', isEqualTo: category.id)
  //       .get()
  //       .then((value) => List<MyTransaction>.from(
  //           value.docs.map((e) => MyTransaction.fromMap(e.data()))))
  //       .then((value) => transactionList = value);

  //   double spent = 0;
  //   double amount = 2000000;
  //   transactionList.map((e) => spent += e.amount).toList();

  //   DateTime now = DateTime.now();
  //   DateTime beginMonth = DateTime(now.year, now.month, 1);
  //   DateTime endMonth = DateTime(now.year, now.month, 30);

  //   Budget budget = Budget(
  //       id: budgetsRef.id,
  //       category: category,
  //       amount: amount,
  //       spent: spent,
  //       walletId: wallet.id,
  //       isFinished: false,
  //       beginDate: beginMonth,
  //       endDate: endMonth,
  //       isRepeat: false);

  //   budgetsRef
  //       .set(budget.toMap())
  //       .then((value) => print('budget added!'))
  //       .catchError((error) => print(error));
  // }

  // BUDGET END //

  // BILL START //
  // BILL END //

  // RECURRING TRANSACTION START //
  // RECURRING TRANSACTION END //

  // EVENT START //

  // add event

  // edit event

  // delete event

  // EVENT END //

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
