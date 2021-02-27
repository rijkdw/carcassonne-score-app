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
            FlatButton(onPressed: onYes, child: Text("Yes")),
            FlatButton(onPressed: onNo, child: Text("No")),
          ],
        ),
      ],
    );
  }
}
