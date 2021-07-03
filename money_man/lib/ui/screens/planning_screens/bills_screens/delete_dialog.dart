import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).pop('only');
              },
              title: Text(
                'Only delete this due',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Style.errorColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Style.foregroundColor.withOpacity(0.12),
              thickness: 0.5,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop('all');
              },
              title: Text(
                'Delete bill(s) for this category',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Style.errorColor,
                ),
                textAlign: TextAlign.center,
              )
            )
          ],
        )
      ),
    );
  }
}
