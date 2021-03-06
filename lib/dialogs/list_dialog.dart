import 'package:flutter/material.dart';

class ListDialog extends StatelessWidget {
  String title;
  List<ListItem> listItems;

  ListDialog({this.title, this.listItems}) {
    listItems ??= <ListItem>[];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            ...listItems
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  String text;
  IconData iconData;
  void Function() onPressed;

  ListItem({this.text, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      onTap: this.onPressed,
      leading: Icon(iconData),
    );
  }
}
