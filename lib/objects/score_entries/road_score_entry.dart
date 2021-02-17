import 'castleable_structure_score_entry.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/map_utils.dart' as map_utils;


class RoadScoreEntry extends CastleableStructureScoreEntry {
  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------
  
  int numSegments;
  bool hasInnOnLake;
  bool finished;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  RoadScoreEntry({
    this.numSegments = 0,
    this.hasInnOnLake = false,
    this.finished = true,
    dynamic castleOwners,
    dynamic followersCount
  }) : super(
    castleOwners: castleOwners,
    followersCount: followersCount
  );

  
  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  @override
  int get structureScore {
    if (finished) {
      if (hasInnOnLake) {
        return 2 * numSegments;
      } else {
        return numSegments;
      }
    } else {
      if (hasInnOnLake) {
        return 0;
      } else {
        return numSegments;
      }
    }
  }

  @override
  String toString() {
    var finishedString = finished ? 'finished' : 'unfinished';
    var innOnLakeString = hasInnOnLake ? 'with an inn on the lake' : 'without an inn on the lake';
    var scoreExplain = '$numSegments segments, $finishedString $innOnLakeString';
    
    var structureNameAndScore = 'A road worth $structureScore points';
    var ownedBy = '${list_utils.sentencify(owners)} (followers: $followersToString)';

    var returnString = '$structureNameAndScore ($scoreExplain) owned by $ownedBy. ';
    returnString += 'Final scores: ${map_utils.mapToString(scoreMap)}.';
    
    return returnString;
  }

}

void main() {
  var road = RoadScoreEntry(
    castleOwners: ['Liza'],
    followersCount: ['Rijk', 'Liza'],
    numSegments: 3
  );
  print(road.toString());
}