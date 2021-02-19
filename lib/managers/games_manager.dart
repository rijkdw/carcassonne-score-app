import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/cloister_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/road_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:flutter/foundation.dart';

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
    games ??= <Game>[game];
  }

  // -------------------------------------------------------------------------------------------------
  // methods
  // -------------------------------------------------------------------------------------------------

  void addNewGame(Game newGame) {
    games.add(newGame);
    notifyListeners();
  }

  void deleteGame(Game game) {
    games.remove(game);
    notifyListeners();
  }

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

}
