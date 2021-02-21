import 'castleable_structure_score_entry.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/map_utils.dart' as map_utils;


class CityScoreEntry extends CastleableStructureScoreEntry {

  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------

  int numSegments;
  int numShields;
  bool hasCathedral;
  bool finished;
  
  
  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  CityScoreEntry({
    this.numSegments = 0,
    this.numShields = 0,
    this.hasCathedral = false,
    this.finished = true,
    dynamic castleOwners,
    dynamic followersCount
  }) : super(
    castleOwners: castleOwners,
    followersCount: followersCount
  );

  // -------------------------------------------------------------------------------------------------
  // JSON
  // -------------------------------------------------------------------------------------------------

  factory CityScoreEntry.fromJSON(Map<String, dynamic> jsonMap) {
    return CityScoreEntry(
      numSegments: jsonMap['num_segments'],
      numShields: jsonMap['num_shields'],
      finished: jsonMap['finished'] ?? true,
      hasCathedral: jsonMap['has_cathedral'] ?? false,
      castleOwners: jsonMap['castle_owners'],
      followersCount: jsonMap['followers_count']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': 'city',
      'num_segments': numSegments,
      'num_shields': numShields,
      'finished': finished,
      'has_cathedral': hasCathedral,
      'castle_owners': castleOwners,
      'followers_count': followersCount
    };
  }

  
  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  @override
  String toString() {
    var finishedString = finished ? 'finished' : 'unfinished';
    var cathedralString = hasCathedral ? 'with a cathedral' : 'without a cathedral';
    var scoreExplain = '$numSegments segments, $numShields shields, $finishedString $cathedralString';
    
    var structureNameAndScore = 'A city worth $structureScore points';
    var ownedBy = '${list_utils.sentencify(owners)} (followers: $followersToString)';
    String castles;
    if (castleOwners.isNotEmpty) {
      castles = '${map_utils.countMapTotal(castleOwners)} castles ($castleOwnersToString)';
    } else {
      castles = 'no castles';
    }

    var returnString = '$structureNameAndScore ($scoreExplain) owned by $ownedBy with $castles. ';
    returnString += 'Final scores: ${map_utils.mapToString(scoreMap)}.';
    
    return returnString;
  }


  @override
  int get structureScore {
    var numSegmentsAndShields = numSegments + numShields;
    if (finished) {
      if (hasCathedral) {
        return 3 * numSegmentsAndShields;
      } else {
        return 2 * numSegmentsAndShields;
      }
    } else {
      if (hasCathedral) {
        return 0;
      } else {
        return numSegmentsAndShields;
      }
    }
  }

}

void main() {
  var city = CityScoreEntry(
    numSegments: 3,
    numShields: 1,
    followersCount: ['Rijk', 'Hanno'],
    castleOwners: ['Liza']
  );
  print(city.toString());
}