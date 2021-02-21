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
    return Scaffold(
      appBar: AppBar(
        title: Text('${game.name} > ${player.name}'),
        backgroundColor: colour_utils.fromText(player.colour),
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
