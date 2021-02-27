import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/list_utils.dart' as list_utils;


class GamesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gamesManager = Provider.of<GamesManager>(context);
    var games = gamesManager.games ?? <Game>[];
    var gamesSplitByState =
        Map<GameState, List<Game>>.from(list_utils.splitListByCallback(games, (game) => game.gameState));
    Widget game2ListTile(Game game) => ChangeNotifierProvider.value(
          value: game,
          child: GameListTile(),
        );
    Widget makeHeaderTile(String word) => ListTile(
          title: Text(
            word,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
    var hasBothOngoingAndFinished = gamesSplitByState.keys.length == 2;
    if (hasBothOngoingAndFinished) {
      return ListView(
        children: [
          makeHeaderTile("Ongoing games"),
          ...gamesSplitByState[GameState.ongoing].map(game2ListTile).toList(),
          makeHeaderTile("Finished games"),
          ...gamesSplitByState[GameState.finished].map(game2ListTile).toList(),
        ],
      );
    } else {
      return ListView(
        children: games.map(game2ListTile).toList(),
      );
    }
    // return ListView(
    //   children: games.map((game) {
    //     return ChangeNotifierProvider.value(
    //       value: game,
    //       child: GameListTile(),
    //     );
    //   }).toList(),
    // );
  }
}
