import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gamesManager = Provider.of<GamesManager>(context);
    var games = gamesManager.games ?? <Game>[];
    return ListView(
      children: games.map((game) {
        return ChangeNotifierProvider.value(
          value: game,
          child: GameListTile(),
        );
      }).toList(),
    );
  }
}
