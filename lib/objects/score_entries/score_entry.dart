import 'package:carcassonne_score_app/objects/score_entries/flat_score_entry.dart';

import 'road_score_entry.dart';
import 'city_score_entry.dart';
import 'cloister_score_entry.dart';
import 'farm_score_entry.dart';

import '../../utils/datetime_utils.dart' as datetime_utils;

abstract class ScoreEntry {
  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------

  DateTime dateCreated;

  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  ScoreEntry({DateTime dateCreated}) {
    this.dateCreated = dateCreated ?? DateTime.now();
  }

  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  Map<String, int> get scoreMap;
  String get properName;
  String get dateCreatedString => datetime_utils.stringify(dateCreated);

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

  static ScoreEntry fromJSON(Map<String, dynamic> jsonMap) {
    switch(jsonMap['type']) {
      case 'city':
        return CityScoreEntry.fromJSON(jsonMap);
      case 'road':
        return RoadScoreEntry.fromJSON(jsonMap);
      case 'farm':
        return FarmScoreEntry.fromJSON(jsonMap);
      case 'cloister':
        return CloisterScoreEntry.fromJSON(jsonMap);
      case 'flat':
        return FlatScoreEntry.fromJSON(jsonMap);
    }
    return null;
  }

  Map<String, dynamic> toJSON();

}