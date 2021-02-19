num maxInList(List<num> theList, {int fallback=-1}) {
  if (theList.isEmpty) return fallback;
  var theMax = theList[0];
  for (var item in theList) {
    if (theMax < item) {
      theMax = item;
    }
  }
  return theMax;
}

List<T> makeList<T>(T item, int repetitions) {
  return List.generate(repetitions, (index) => item);
}

String sentencify<T>(List<T> list) {
  if (list.isEmpty) {
    return '';
  }
  if (list.length == 1) {
    return list.first.toString();
  }
  if (list.length == 2) {
    return '${list.first} and ${list.last}';
  }
  
  var returnString = '';
  for (var i = 0; i < list.length-1; i++) {
    returnString += list[i].toString() + ', ';
  }
  returnString += 'and ${list.last}';
  return returnString;
}

int count<T>(List<T> list, T target) {
  var counter = 0;
  for (var item in list) {
    if (item == target) {
      counter++;
    }
  }
  return counter;
}

List<T> intersperse<T>(List<T> list, T Function() callback) {
  if (list.length < 2) return list;
  var returnList = <T>[];
  for (var i = 0; i < list.length-1; i++) {
    returnList.add(list[i]);
    returnList.add(callback());
  }
  returnList.add(list.last);
  return returnList;
}

String join(List<dynamic> list, String delim) {
  if (list.isEmpty) return '';
  if (list.length == 1) return list.first;
  var output = '';
  for (var i = 0; i < list.length-1; i++) {
    output += list[i].toString();
    output += delim;
  }
  output += list.last;
  return output;
}

void main(List<String> args) {
  print(maxInList([1, 3, 5, 2, 3]));
}