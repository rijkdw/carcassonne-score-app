import 'dart:convert';

import 'structure_score_entry.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/map_utils.dart' as map_utils;


class FarmScoreEntry extends StructureScoreEntry {
  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------
  
  int numCities;
  int numCastles;
  bool hasBarn;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  FarmScoreEntry({
    this.numCastles = 0,
    this.numCities = 0,
    this.hasBarn = false,
    dynamic followersCount
  }) : super(
    followersCount: followersCount
  );

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

  factory FarmScoreEntry.fromJSON(Map<String, dynamic> jsonMap) {
    return FarmScoreEntry(
      followersCount: jsonMap['followers_count'],
      hasBarn: jsonMap['has_barn'] ?? false,
      numCastles: jsonMap['num_castles'],
      numCities: jsonMap['num_cities']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': 'farm',
      'followers_count': followersCount,
      'has_barn': hasBarn,
      'num_castles': numCastles,
      'num_cities': numCities
    };
  }

  
  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  @override
  String get properName => 'Farm';

  @override
  int get structureScore {
    if (hasBarn) {
      return 5 * numCastles + 4 * numCities;
    } else {
      return 4 * numCastles + 3 * numCities;
    }
  }

  @override
  String toString() {
    var cityMult = hasBarn ? 4 : 3;
    var castleMult = hasBarn ? 5 : 4;
    var scoreExplain = '$numCities cities worth $cityMult each, $numCastles castles worth $castleMult each';
    
    var structureNameAndScore = 'A farm worth $structureScore points';
    var ownedBy = '${list_utils.sentencify(owners)} (followers: $followersToString)';

    var returnString = '$structureNameAndScore ($scoreExplain) owned by $ownedBy. ';
    returnString += 'Final scores: ${map_utils.mapToString(scoreMap)}.';
    
    return returnString;
  }


}

void main() {
  var farm = FarmScoreEntry(
    followersCount: ['Rijk'],
    numCastles: 1,
    numCities: 4,
  );
  print(farm.toString());
}