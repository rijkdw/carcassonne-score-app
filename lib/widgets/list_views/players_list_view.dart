import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/player_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = Provider.of<Game>(context);
    return ListView(
      children: game.players.map((player) {
        return Provider.value(
          value: player,
          child: PlayerListTile(),
        );
      }).toList(),
    );
  }
}
