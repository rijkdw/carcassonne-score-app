import 'list_utils.dart' as list_utils;


List<T> keysOfMaxValues<T>(Map<T, int> theMap) {
  var maxInValues = list_utils.maxInList(theMap.values.toList());
  var keysOfMaxValues = <T>[];
  for (var key in theMap.keys) {
    if (theMap[key] == maxInValues) {
      keysOfMaxValues.add(key);
    }
  }
  return keysOfMaxValues;
}


String mapToString<T, V>(Map<T, V> map) {
  var returnList = <String>[];
  for (var key in map.keys) {
    returnList.add('${key.toString()}: ${map[key].toString()}');
  }
  return list_utils.join(returnList, ', ');
}


int countMapTotal<T>(Map<T, int> map) {
  var total = 0;
  for (var val in map.values) {
    total += val;
  }
  return total;
}


Map<T, int> listToCountMap<T>(List<T> list) {
  var returnMap = <T, int>{};
  for (var item in list) {
    if (!returnMap.keys.contains(item)) {
      returnMap[item] = 0;
    }
    returnMap[item]++;
  }
  return returnMap;
}


Map<T, num> accumulateMaps<T>(List<Map<T, num>> maps) {
  var returnMap = <T, num>{};
  for (var map in maps) {
    for (var key in map.keys) {
      if (!returnMap.containsKey(key)) {
        returnMap[key] = 0;
      }
      returnMap[key] += map[key];
    }
  }
  return returnMap;
}


bool isEqual(Map<dynamic, dynamic> mapA, Map<dynamic, dynamic> mapB) {
  for (var keyA in mapA.keys) {
    if (!mapB.containsKey(keyA)) {
      return false;
    }
    if (mapA[keyA] != mapB[keyA]) {
      return false;
    }
  }
  for (var keyB in mapB.keys) {
    if (!mapA.containsKey(keyB)) {
      return false;
    }
    if (mapB[keyB] != mapA[keyB]) {
      return false;
    }
  }
  return true;
}


void main(List<String> args) {
  print(keysOfMaxValues({"a": 4, "b": 2, "c": 5, "d": 5}));
  print(accumulateMaps([
    {"Rijk": 4, "Liza": 2},
    {"Liza": 4, "Carlyle": 2},
    {"Thomas": 12}
  ]));
  print(isEqual({"A": 1}, {"B": 1}));
}