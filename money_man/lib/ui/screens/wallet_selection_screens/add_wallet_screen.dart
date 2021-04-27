import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:money_man/ui/screens/currency_selection_screen/currency_selection.dart';
import 'package:page_transition/page_transition.dart';

class AddWalletScreen extends StatefulWidget {
  @override
  _AddWalletScreenState createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        title: Text('Add Wallet', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 15.0)),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600,),
          ),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.transparent,
          )
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {},
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600,),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )),
        ],
      ),
      body: Container(
        color: Colors.black26,
        child: ListView(
            children: [MainActivity()]
        )
      ),
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
        Container(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 35.0, horizontal: 0.0),
            child: Column(
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_balance_wallet, size: 35.0,),
                      onPressed: () {
                        // TODO: Chọn icon cho ví
                      },
                      iconSize: 70,
                      color: Color(0xff8f8f8f),
                    ),
                    Container(
                        width: 250,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          style: TextStyle(color: Colors.white, decoration: TextDecoration.none,),
                          decoration: InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 1),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 3),
                              ),
                              // border: UnderlineInputBorder(
                              //   borderSide:
                              //       BorderSide(color: Colors.white60, width: 3),
                              // ),
                              labelText: 'Name',
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
                    )
                  ],
                ),
                Divider(
                  thickness: 0.05,
                  color: Colors.white,
                ),
                // Row(
                //   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.monetization_on_outlined, size: 40.0),
                //       onPressed: () {},
                //       color: Color(0xff8f8f8f),
                //     ),
                //     Currency(),
                //   ],
                // ),
                ListTile(
                  onTap: () {
                    showCurrencyPicker(
                      context: context,
                      showFlag: true,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                    );
                  },
                  dense: true,
                  leading: Icon(Icons.monetization_on, size: 30.0, color: Colors.white60),
                  title: Text('Currency', style: TextStyle(color: Colors.white24, fontSize: 15.0)),
                  trailing: Icon(Icons.chevron_right, size: 20.0, color: Colors.white24),
                ),
                Divider(
                  thickness: 0.05,
                  color: Colors.white,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.confirmation_number_outlined),
                //       onPressed: () {},
                //       iconSize: 40,
                //       color: Color(0xff8f8f8f),
                //     ),
                //     Container(
                //         width: 275,
                //         child: Theme(
                //           data: ThemeData(
                //             primaryColor: Colors.white70,
                //             fontFamily: 'Monserrat',
                //             secondaryHeaderColor: Colors.white,
                //           ),
                //           child: TextFormField(
                //             style: TextStyle(fontSize: 13),
                //             decoration: const InputDecoration(
                //                 enabledBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: Colors.white60),
                //                 ),
                //                 focusedBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: Colors.white60),
                //                 ),
                //                 border: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: Colors.white60),
                //                 ),
                //                 labelText: 'Amount *',
                //                 labelStyle: TextStyle(color: Colors.white60)),
                //             onSaved: (value) {
                //               // This optional block of code can be used to run
                //               // code when the user saves the form.
                //             },
                //             validator: (value) {
                //               return (value != null && value.contains('@'))
                //                   ? 'Do not use the @ char.'
                //                   : null;
                //             },
                //           ),
                //         ))
                //   ],
                // ),
                ListTile(
                  onTap: () {},
                  dense: true,
                  leading: Icon(Icons.account_balance, size: 30.0, color: Colors.white60),
                  title: Text('Initial Balance', style: TextStyle(color: Colors.white60, fontSize: 12.0)),
                  subtitle: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 12.0),
                    padding: EdgeInsets.fromLTRB(0, 0, 30.0, 0.0),
                    height: 30,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none,),
                      decoration: InputDecoration(
                          errorBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white60, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white60, width: 3),
                          ),
                          // border: UnderlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white60, width: 3),
                          // ),
                      ),
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
                  ),
                ),
              ],
            ),
          ),
        // SizedBox(
        //   height: 25,
        //   child: Container(height: 50, color: Color(0xff6f6f6f)),
        // ),
        // SizedBox(
        //   height: 25,
        // ),
        GestureDetector(
          onTap: () {
            // Xử lý sự kiện click ở đây.
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.grey[900],
            child: Text(
            'Link to service',
            style: TextStyle(
              color: Colors.green,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat'
              ),
            ),
          ),
        ),
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
