import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  String title;
  void Function() onYes;
  void Function() onNo;

  YesNoDialog({@required this.title, @required this.onYes, @required this.onNo});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(this.title),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              onPressed: () {
                onYes();
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            FlatButton(
              onPressed: () {
                onNo();
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        ),
      ],
    );
  }
}
