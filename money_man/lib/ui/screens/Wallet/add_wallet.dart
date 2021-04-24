import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AddWallet extends StatefulWidget {
  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'Add Wallet',
          style: TextStyle(
            fontSize: 27,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD54F),
          ),
        ),
        leadingWidth: 75,
        leading: TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Colors.white70, fontSize: 15, fontFamily: 'Montserrat'),
          ),
        ),
        actions: [
          TextButton(
              child: Text(
            'Save',
            style: TextStyle(
                color: Colors.white70, fontSize: 15, fontFamily: 'Montserrat'),
          ))
        ],
        centerTitle: true,
      ),
      body: MainActivity(),
    );
  }
}

class MainActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 25,
          child: Container(
            height: 50,
            color: Color(0xff6f6f6f),
          ),
        ),
        Container(
          color: Color(0xff141414),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_balance_wallet),
                    onPressed: () {
                      // TODO: Chọn icon cho ví
                    },
                    iconSize: 70,
                    color: Color(0xff8f8f8f),
                  ),
                  Container(
                      width: 250,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.white70,
                          fontFamily: 'Monserrat',
                          secondaryHeaderColor: Colors.white,
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 3),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 3),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 3),
                              ),
                              labelText: 'Name *',
                              labelStyle: TextStyle(color: Colors.white60)),
                          onSaved: (value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (value) {
                            return (value != null && value.contains('@'))
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                      ))
                ],
              ),
              Divider(
                thickness: 2,
                color: Colors.white10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.monetization_on_outlined),
                    onPressed: () {},
                    iconSize: 40,
                    color: Color(0xff8f8f8f),
                  ),
                  Currency(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.confirmation_number_outlined),
                    onPressed: () {},
                    iconSize: 40,
                    color: Color(0xff8f8f8f),
                  ),
                  Container(
                      width: 275,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.white70,
                          fontFamily: 'Monserrat',
                          secondaryHeaderColor: Colors.white,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60),
                              ),
                              labelText: 'Amount *',
                              labelStyle: TextStyle(color: Colors.white60)),
                          onSaved: (value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (value) {
                            return (value != null && value.contains('@'))
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25,
          child: Container(height: 50, color: Color(0xff6f6f6f)),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
          decoration: BoxDecoration(
              color: Color(0xFFFFD54F),
              borderRadius: BorderRadius.circular(30)),
          child: Text(
            'Link to service',
            style: TextStyle(
                color: Color(0xff1a1a1a),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          ),
        )
      ],
    );
  }
}

class Currency extends StatefulWidget {
  @override
  _CurrencyState createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  String dropdownValue = 'VND';
  List ListItem = ['VND', 'USD', 'WON', 'BITCOIN'];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white60),
        ),
      ),
      width: 275,
      height: size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Currency *',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          SizedBox(width: 40.0),
          Container(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.black,
                hint: Text(
                  'Currency',
                  style: TextStyle(
                    fontFamily: 'NarumGothic',
                  ),
                ),
                value: dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: ListItem.map((dropdownValue) {
                  return DropdownMenuItem(
                    value: dropdownValue,
                    child: Text(
                      dropdownValue,
                      style: TextStyle(
                          fontFamily: 'Montserrat', color: Colors.white60),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
