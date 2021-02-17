import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = Provider.of<Game>(context);
    return ListTile(
      title: Text(game.name),
      trailing: Icon(Icons.more_vert),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider.value(
            value: game,
            child: GameScreen(),
          );
        }));
      },
    );
  }
}
