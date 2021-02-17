import 'structure_score_entry.dart';

import '../../utils/map_utils.dart' as map_utils;
import '../../utils/list_utils.dart' as list_utils;


abstract class CastleableStructureScoreEntry extends StructureScoreEntry {

  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------

  Map<String, int> castleOwners;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  CastleableStructureScoreEntry({dynamic castleOwners, dynamic followersCount}) 
  : super(followersCount: followersCount) {
    if (castleOwners is List<String>) {
      this.castleOwners = map_utils.listToCountMap(castleOwners);
    } else {
      this.castleOwners = castleOwners;
    }
    this.castleOwners ??= <String, int>{};
  }


  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  @override
  Map<String, int> get scoreMap {
    var baseScoreMap = super.scoreMap;
    var castleScoreMap = <String, int>{};
    for (var key in (castleOwners ?? {}).keys) {
      castleScoreMap[key] = structureScore * castleOwners[key];
    }
    return Map<String, int>.from(map_utils.accumulateMaps([baseScoreMap, castleScoreMap]));
  }

  String get castleOwnersToString {
    var returnList = <String>[];
    for (var playerName in castleOwners.keys) {
      var numFollowers = castleOwners[playerName];
      returnList.add('$playerName has $numFollowers');
    }
    return list_utils.join(returnList, ', ');
  }


}