import 'dart:convert';

import 'package:flutter/material.dart';

import 'player.dart';
import 'score_entries/score_entry.dart';

import '../utils/map_utils.dart' as map_utils;

enum GameState{
  finished, ongoing
}


class Game extends ChangeNotifier {

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

  Game({this.name='New game', this.playerNames, this.playerColours, this.scoreEntries}) {
    playerNames ??= <String>[];
    playerColours ??= <String>[];
    scoreEntries ??= <ScoreEntry>[];
  }

  factory Game.dummy() => Game(
    name: 'Dummy Game',
    playerColours: ['Red', 'Blue'],
    playerNames: ['Liza', 'Rijk'],
  );
  
  // ------------------------------------------------------------
  // methods
  // ------------------------------------------------------------

  void addScoreEntry(ScoreEntry scoreEntry) {
    scoreEntries.add(scoreEntry);
    notifyListeners();
  }

  void removeScoreEntry(ScoreEntry scoreEntry) {
    scoreEntries.remove(scoreEntry);
    notifyListeners();
  }

  List<ScoreEntry> getScoreEntriesBenefitting(String playerName) {
    var returnList = <ScoreEntry>[];
    for (var scoreEntry in scoreEntries) {
      if (scoreEntry.scoreMap.containsKey(playerName)) {
        returnList.add(scoreEntry);
      }
    }
    return returnList;
  }


  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  Map<String, int> get namesToScores {
    var map = Map<String, int>.from(map_utils.accumulateMaps(scoreEntries.map((e) => e.scoreMap).toList()));
    for (var name in playerNames) {
      if (!map.keys.contains(name)) {
        map[name] = 0;
      }
    }
    return map;
  }

  GameState get gameState => name == "Dummy Game" ? GameState.finished : GameState.ongoing;

  List<Player> get players {
    var namesToScoresSaved = namesToScores;
    var players = List.generate(playerNames.length, (i) {
      return Player(
        name: playerNames[i],
        colour: playerColours[i],
        score: namesToScoresSaved[playerNames[i]],
      );
    });
    players.sort((a, b) => -a.score.compareTo(b.score));
    return players;
  }

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

  factory Game.fromJSON(Map<String, dynamic> jsonMap) {
    var name = jsonMap['name'];
    var playerNames = List<String>.from(jsonMap['player_names']);
    var playerColours = List<String>.from(jsonMap['player_colours']);
    var scoreEntries = List<ScoreEntry>.from(jsonMap['score_entries'].map((submap) => ScoreEntry.fromJSON(submap)).toList());
    return Game(
      name: name,
      playerNames: playerNames,
      playerColours: playerColours,
      scoreEntries: scoreEntries,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'player_names': playerNames,
      'player_colours': playerColours,
      'score_entries': scoreEntries.map((scoreEntry) => scoreEntry.toJSON()).toList(),
    };
  }

}