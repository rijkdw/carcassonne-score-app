import 'package:carcassonne_score_app/managers/previous_players_manager.dart';
import 'package:carcassonne_score_app/screens/previous_players_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
            // player names screen
            _DrawerItemListTile(
              text: "Previous players",
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return PreviousPlayersScreen();
              })),
            ),
            // debug button
            _DrawerItemListTile(
              text: "DEBUG",
              onPressed: () {
                Provider.of<PreviousPlayersManager>(context, listen: false).addDummyNames();
              },
            ),
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

  _DrawerItemListTile({this.text = "OPTION", this.iconData = Icons.help, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed ?? () {},
      title: Text(text),
      leading: Icon(iconData),
    );
  }
}
