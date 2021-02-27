import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/screens/new_game_screen.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/player_list_tile.dart';
import 'package:carcassonne_score_app/widgets/list_views/players_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gamesManager = Provider.of<GamesManager>(context);
    var game = Provider.of<Game>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              var scoreEntry = CityScoreEntry(
                numSegments: 100,
                followersCount: ['Liza']
              );
              game.addScoreEntry(scoreEntry);
              gamesManager.changeMadeSequence();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: PlayersListView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add points'),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider.value(
              value: game,
              child: NewScoreEntryScreen(),
            );
          }));
        },
      ),
    );
  }
}
