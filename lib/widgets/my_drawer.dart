import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.house_rounded,
                      color: Colors.white,
                      size: 45,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Carcassonne Scoreboard',
                      style: TextStyle(color: Colors.white, fontSize: 30, letterSpacing: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            // an option
            _DrawerItemListTile(
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class _DrawerItemListTile extends StatelessWidget {
  String text;
  IconData iconData;
  VoidCallback onPressed;
  
  _DrawerItemListTile({this.text="OPTION", this.iconData=Icons.help, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed ?? () {},
      title: Text(text),
      leading: Icon(iconData),
    );
  }
}
