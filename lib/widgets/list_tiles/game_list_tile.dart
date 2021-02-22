import 'package:carcassonne_score_app/managers/games_manager.dart';
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
      trailing: InkWell(
        child: Container(
          padding: EdgeInsets.all(4),
          child: Icon(Icons.delete),
        ),
        onTap: () {
          // TODO a confirm button ("are you sure you want to delete this game?")
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Deleted game \"${game.name}\".'),
            duration: Duration(seconds: 2),
          ));
          Provider.of<GamesManager>(context, listen: false).deleteGame(game);
        },
      ),
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
