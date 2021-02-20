import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/screens/new_game_screen.dart';
import 'package:carcassonne_score_app/widgets/list_views/games_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gamesManager = Provider.of<GamesManager>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
        actions: [
          IconButton(
            icon: Icon(Icons.sd_storage),
            onPressed: () {
              gamesManager.storeInLocal();
              gamesManager.loadFromLocal();
            },
          ),
        ],
      ),
      body: GamesListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewGameScreen();
          }));
        },
      ),
    );
  }
}
