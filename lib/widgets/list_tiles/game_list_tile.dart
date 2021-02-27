import 'package:carcassonne_score_app/dialogs/yes_no_dialog.dart';
import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameListTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var game = Provider.of<Game>(context);

    void showSnackBar(String text) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ));
    }

    return ListTile(
      title: Text(game.name),
      trailing: InkWell(
        child: Container(
          padding: EdgeInsets.all(4),
          child: Icon(Icons.delete),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return YesNoDialog(
                  title: "Delete game ${game.name}?",
                  onYes: () {
                    showSnackBar('Deleted game \"${game.name}\".');
                    Provider.of<GamesManager>(context, listen: false).deleteGame(game);
                  },
                  onNo: () {},
                );
              });
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
