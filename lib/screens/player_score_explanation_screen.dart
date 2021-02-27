import 'package:carcassonne_score_app/dialogs/yes_no_dialog.dart';
import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/list_utils.dart' as list_utils;
import '../utils/colour_utils.dart' as colour_utils;

class PlayerScoreExplanationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context);
    var game = Provider.of<Game>(context);
    var gamesManager = Provider.of<GamesManager>(context);
    var scoreEntries = game.getScoreEntriesBenefitting(player.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('${game.name} > ${player.name}'),
        backgroundColor: colour_utils.fromText(player.colour),
      ),
      body: scoreEntries.isEmpty
          ? Center(
              child: Text('No points :('),
            )
          : ListView(
              children: list_utils.intersperse(
                  scoreEntries.map((scoreEntry) {
                    return ListTile(
                      title: Text(scoreEntry.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => YesNoDialog(
                              title: "Delete ScoreEntry?",
                              onYes: () {
                                game.removeScoreEntry(scoreEntry);
                                gamesManager.changeMadeSequence();
                                Navigator.of(context).pop();
                              },
                              onNo: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  () => Divider()),
            ),
    );
  }
}
