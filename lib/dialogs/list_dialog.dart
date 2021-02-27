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
      child: Column(
        children: [
          Text(title),
          Divider(),
          ...listItems
        ],
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
      onTap: onPressed,
      leading: Icon(iconData),
    );
  }
}
