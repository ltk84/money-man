import 'package:flutter/material.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: StreamBuilder<List<MyCatergory>>(
          stream: _firestore.categoryStream,
          builder: (context, snapshot) {
            final _listCategories = snapshot.data ?? [];
            return ListView.builder(
                itemCount: _listCategories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.ac_unit_sharp),
                    title: Text(_listCategories[index].name),
                    onTap: () {},
                  );
                });
          }),
    );
  }
}
