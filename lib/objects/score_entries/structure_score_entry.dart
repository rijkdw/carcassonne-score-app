import 'score_entry.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/map_utils.dart' as map_utils;


abstract class StructureScoreEntry extends ScoreEntry {

  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------

  Map<String, int> followersCount;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  /// [followerCounts] can be a List (e.g. ['Rijk', 'Liza', 'Liza'])
  /// or a Map (e.g. {'Rijk': 1, 'Liza': 2})
  StructureScoreEntry({dynamic followersCount}) {
    if (followersCount is List<String>) {
      this.followersCount = map_utils.listToCountMap(followersCount);
    }
    else {
      this.followersCount = followersCount;
    }
  }

  
  // ------------------------------------------------------------
  // getters
  // ------------------------------------------------------------

  int get structureScore;

  List<String> get owners => map_utils.keysOfMaxValues(followersCount);
  
  String get followersToString {
    var returnList = <String>[];
    for (var playerName in followersCount.keys) {
      var numFollowers = followersCount[playerName];
      returnList.add('$playerName has $numFollowers');
    }
    return list_utils.join(returnList, ', ');
  }

  @override
  Map<String, int> get scoreMap => Map<String, int>.fromIterables(owners, list_utils.makeList(structureScore, owners.length));

}