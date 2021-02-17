import 'player.dart';
import 'score_entries/score_entry.dart';

import '../utils/map_utils.dart' as map_utils;


class Game {

  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------
  
  String name;
  List<String> playerNames;
  List<String> playerColours;
  List<ScoreEntry> scoreEntries;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  Game({this.name='New game', this.playerNames, this.playerColours}) {
    playerNames ??= <String>[];
    playerColours ??= <String>[];
    scoreEntries = [];
  }
  
  // ------------------------------------------------------------
  // methods
  // ------------------------------------------------------------

  void addScoreEntry(ScoreEntry scoreEntry) {
    scoreEntries.add(scoreEntry);
    // TODO notifyListeners();
  }

  void removeScoreEntry(ScoreEntry scoreEntry) {
    scoreEntries.remove(scoreEntry);
    // TODO notifyListeners();
  }


  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  Map<String, int> get namesToScores {
    return Map<String, int>.from(map_utils.accumulateMaps(scoreEntries.map((e) => e.scoreMap).toList()));
  }

  List<Player> get players {
    var namesToScoresSaved = namesToScores;
    return List.generate(playerNames.length, (i) {
      return Player(
        name: playerNames[i],
        colour: playerColours[i],
        score: namesToScoresSaved[playerNames[i]],
      );
    });
  }
}