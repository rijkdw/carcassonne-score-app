import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/cloister_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/farm_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/flat_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/road_score_entry.dart';
import 'package:carcassonne_score_app/screens/new_game_screen.dart';
import 'package:carcassonne_score_app/widgets/list_views/games_list_view.dart';
import 'package:carcassonne_score_app/widgets/my_drawer.dart';
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
          // TODO remove this button
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              var game = Game(
                playerNames: ['Rijk', 'Liza'],
                playerColours: ['blue', 'red'],
                name: 'Dummy Game',
                scoreEntries: [
                  CityScoreEntry(followersCount: ['Rijk'], numSegments: 2),
                  RoadScoreEntry(followersCount: ['Liza'], numSegments: 2, castleOwners: ['Rijk']),
                  CloisterScoreEntry(numTiles: 8, followersCount: ['Liza']),
                  FarmScoreEntry(followersCount: ['Rijk', 'Liza', 'Liza'], numCities: 3),
                  FlatScoreEntry(score: 10, playerNames: ['Rijk', 'Liza']),
                ],
              );
              gamesManager.addNewGame(game);
              var emptyGame = Game(
                playerNames: ['Rijk', 'Liza'],
                playerColours: ['blue', 'red'],
                name: 'empty game',
              );
              gamesManager.addNewGame(emptyGame);
              var manualsGame = Game(
                playerNames: ['Rijk', 'Liza'],
                playerColours: ['blue', 'red'],
                name: 'Flats',
                scoreEntries: [
                  FlatScoreEntry(score: 10, playerNames: ['Rijk', 'Liza']),
                  FlatScoreEntry(score: 20, playerNames: ['Liza', 'Rijk']),
                  FlatScoreEntry(score: 5, playerNames: ['Liza']),
                  FlatScoreEntry(score: 7, playerNames: ['Rijk']),
                ],
              );
              gamesManager.addNewGame(manualsGame);
            },
          ),
          // TODO remove this button
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              gamesManager.deleteAllGames();
            },
          )
        ],
      ),
      drawer: MyDrawer(),
      drawerEdgeDragWidth: double.infinity,
      body: GamesListView(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('New Game'),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewGameScreen();
          }));
        },
      ),
    );
  }
}
