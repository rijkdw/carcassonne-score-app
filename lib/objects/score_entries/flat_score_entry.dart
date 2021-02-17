import 'score_entry.dart';

import '../../utils/list_utils.dart' as list_utils;


class FlatScoreEntry extends ScoreEntry {

  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------
  
  int score;
  List<String> playerNames;

  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------
  
  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  @override
  Map<String, int> get scoreMap {
    return Map<String, int>.fromIterables(playerNames, list_utils.makeList(score, playerNames.length));
  }
  
}