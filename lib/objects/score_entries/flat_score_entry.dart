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

  FlatScoreEntry({this.score, this.playerNames}) {
    this.playerNames ??= <String>[];
  }

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

  factory FlatScoreEntry.fromJSON(Map<String, dynamic> jsonMap) {
    return FlatScoreEntry(
      score: jsonMap['score'],
      playerNames: List<String>.from(jsonMap['player_names']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {'type': 'flat', 'score': score, 'player_names': playerNames};
  }

  // -------------------------------------------------------------------------------------------------
  // methods
  // -------------------------------------------------------------------------------------------------

  @override
  String toString() => 'A flat score increase of $score to ${list_utils.sentencify(playerNames)}.';

  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  @override
  Map<String, int> get scoreMap {
    return Map<String, int>.fromIterables(playerNames, list_utils.makeList(score, playerNames.length));
  }
}
