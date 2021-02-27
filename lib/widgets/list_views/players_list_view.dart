import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/player_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

class PlayersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = Provider.of<Game>(context);
    return ImplicitlyAnimatedList<Player>(
      items: game.players,
      areItemsTheSame: (a, b) => a.name == b.name,
      itemBuilder: (context, animation, player, index) {
        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOut,
          animation: animation,
          child: Provider.value(
            value: player,
            child: PlayerListTile(),
          ),
        );
      },
    );
    // return ListView(
    //   children: game.players.map((player) {
    //     return Provider.value(
    //       value: player,
    //       child: PlayerListTile(),
    //     );
    //   }).toList(),
    // );
  }
}
