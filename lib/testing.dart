import 'objects/score_entries/castleable_structure_score_entry.dart';
import 'objects/score_entries/city_score_entry.dart';
import 'objects/game.dart';
import 'objects/score_entries/road_score_entry.dart';
import 'objects/score_entries/structure_score_entry.dart';
import 'utils/list_utils.dart' as list_utils;
import 'utils/map_utils.dart' as map_utils;

class Test {

  String name;
  int repeats;
  bool Function() testCallback;
  bool _success;

  Test(this.name, this.testCallback, {this.repeats=1});

  void performTest() {
    var failures = 0;
    for (var i = 0; i < repeats; i++) {
      if (!testCallback()) {
        failures++;
      }
    }
    _success = failures == 0;
  }

  bool get success => _success;
  bool get failure => !success;

}

class TestsList {

  List<Test> tests;

  TestsList(this.tests);

  int get count => tests.length;
  int get countSuccesses {
    var c = 0;
    tests.forEach((test) => c += test.success ? 1 : 0);
    return c;
  }
  int get countFailures => count - countSuccesses;

  bool get hasFailures => countFailures > 0;

  List<String> get failureNames {
    var list = <String>[];
    tests.forEach((test) {
      if (test.failure) list.add(test.name);
    });
    return list;
  }

  void performTests() {
    tests.forEach((test) => test.performTest());
  }

  void printLog() {
    if (countFailures == 0) {
      print('All $count tests passed.');
    } else {
      // print number of failures out of total
      print('$countFailures out of $count tests failed.');
      // print failed tests
      print('Failed tests:');
      print(list_utils.join(failureNames, '\n'));
    }
    
  }

}

void main() {
  var tests = TestsList([

    Test('City points', () {
      var city = CityScoreEntry(
        numSegments: 2,
        castleOwners: ['Rijk', 'Rijk', 'Liza'],
        followersCount: {'Carlyle': 2, 'Rijk': 1},
        finished: true
      );
      return map_utils.isEqual(city.scoreMap, {'Carlyle': 4, 'Rijk': 8, 'Liza': 4});
    }),

    Test('City points', () {
      var city = CityScoreEntry(
        numSegments: 2,
        castleOwners: ['Rijk', 'Rijk', 'Liza'],
        followersCount: {'Carlyle': 2, 'Rijk': 1},
        finished: false
      );
      return map_utils.isEqual(city.scoreMap, {'Carlyle': 2, 'Rijk': 4, 'Liza': 2});
    }),

    Test('Game mechanics', () {
      // make the game and add some points
      var game = Game(
        name: 'New Game',
        playerNames: ['Rijk', 'Liza', 'Carlyle'],
        playerColours: ['Blue', 'Red', 'Green']
      );
      // this should give 6 points to Carlyle and 6 to Liza
      game.addScoreEntry(CityScoreEntry(
        numSegments: 2,
        numShields: 1,
        followersCount: {'Carlyle': 2, 'Rijk': 1},
        castleOwners: ['Liza'],
        finished: true
      ));
      // this should give 3 points to Liza and 3 to Rijk
      game.addScoreEntry(RoadScoreEntry(
        followersCount: {'Liza': 1, 'Rijk': 1},
        numSegments: 3,
        finished: true
      ));

      var players = game.players;
      var expectedScores = {'Rijk': 3, 'Liza': 9, 'Carlyle': 6};
      for (var player in players) {
        if (expectedScores[player.name] != player.score) {
          return false;
        }
      }
      return true;

    }),

  ]);

  tests.performTests();
  tests.printLog();

}