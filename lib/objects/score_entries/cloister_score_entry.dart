import 'castleable_structure_score_entry.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/map_utils.dart' as map_utils;


class CloisterScoreEntry extends CastleableStructureScoreEntry {
  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------
  
  int numTiles;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  CloisterScoreEntry({
    this.numTiles = 0,
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
  String toString() {
    var scoreExplain = '$numTiles tiles';
    
    var structureNameAndScore = 'A cloister worth $structureScore points';
    var ownedBy = '${owners.first}';
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
  int get structureScore => numTiles + 1;

}

void main() {
  var cloister = CloisterScoreEntry(
    castleOwners: ['Liza'],
    numTiles: 8,
    followersCount: ['Rijk']
  );
  print(cloister.toString());
}