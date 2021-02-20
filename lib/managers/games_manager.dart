import 'dart:convert';

import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/cloister_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/road_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamesManager extends ChangeNotifier {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------

  List<Game> games;

  // -------------------------------------------------------------------------------------------------
  // constructor
  // -------------------------------------------------------------------------------------------------

  GamesManager({this.games}) {
    var dummyScoreEntries = <ScoreEntry>[
      CityScoreEntry(followersCount: ['Rijk'], numSegments: 2),
      RoadScoreEntry(followersCount: ['Liza'], numSegments: 2),
      CloisterScoreEntry(numTiles: 8, followersCount: ['Liza'])
    ];
    var game = Game(
      name: 'Friday Night Game',
      playerNames: ['Rijk', 'Liza'],
      playerColours: ['blue', 'red'],
    );
    for (var scoreEntry in dummyScoreEntries) {
      game.addScoreEntry(scoreEntry);
    }
  }

  // -------------------------------------------------------------------------------------------------
  // methods
  // -------------------------------------------------------------------------------------------------

  void changeMadeSequence() {
    storeInLocal();
    notifyListeners();
  }

  void addNewGame(Game newGame) {
    games.add(newGame);
    changeMadeSequence();
  }

  void deleteGame(Game game) {
    games.remove(game);
    changeMadeSequence();
  }

  void deleteAllGames() {
    games.removeWhere((game) => true);
    changeMadeSequence();
  }

  // -------------------------------------------------------------------------------------------------
  // storage
  // -------------------------------------------------------------------------------------------------

  static const _GAMES_KEY = 'games';

  void loadFromLocal() async {
    var prefs = await SharedPreferences.getInstance();
    games = List<Game>.from(jsonDecode(prefs.getString(_GAMES_KEY)).map((gameMap) => Game.fromJSON(gameMap)));
    notifyListeners();
  }

  void storeInLocal() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_GAMES_KEY, jsonEncode(games.map((game) => game.toJSON()).toList()));
  }

}
