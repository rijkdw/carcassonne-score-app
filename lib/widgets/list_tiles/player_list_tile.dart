import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:carcassonne_score_app/screens/score_explanation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colour_utils.dart' as colour_utils;

class PlayerListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = Provider.of<Game>(context);
    var player = Provider.of<Player>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colour_utils.fromText(player.colour),
        child: Container(
          child: Text(
            '${player.score}',
            style: TextStyle(color: colour_utils.highContrastColourTo(player.colour), fontSize: 20),
          ),
        ),
      ),
      title: Text(player.name),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: game),
                Provider.value(value: player),
              ],
              child: NewScoreEntryScreen(
                initiallySelectedPlayers: [player.name],
              ),
            );
          }));
        },
      ),
      onTap: () {
        // opens to NewScoreEntryScreen with this player already selected
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: game),
              Provider.value(value: player),
            ],
            child: ScoreExplanationScreen(),
          );
        }));
      },
    );
  }
}
