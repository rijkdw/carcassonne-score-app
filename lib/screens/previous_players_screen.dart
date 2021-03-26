import 'package:carcassonne_score_app/dialogs/yes_no_dialog.dart';
import 'package:carcassonne_score_app/managers/previous_players_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviousPlayersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var previousPlayersManager = Provider.of<PreviousPlayersManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Previous players"),
      ),
      body: previousPlayersManager.previousPlayerNames.isEmpty
          ? Center(
              child: Text("No previous players"),
            )
          : ListView(
              children: previousPlayersManager.previousPlayerNames.map((name) {
                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return YesNoDialog(
                            title: "Forget $name?",
                            onYes: () {
                              previousPlayersManager.deleteName(name);
                            },
                            onNo: () {},
                          );
                        },
                      );
                    },
                  ),
                );
              }).toList(),
            ),
    );
  }
}
