import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/list_utils.dart' as list_utils;


class PlayerScoreExplanationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context);
    var game = Provider.of<Game>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${player.name} in ${game.name}"),
      ),
      body: ListView(
        children: list_utils.intersperse(game.getScoreEntriesBenefitting(player.name).map((scoreEntry) {
          return ListTile(
            title: Text(scoreEntry.toString()),
          );
        }).toList(), () => Divider()),
      ),
    );
  }
}
