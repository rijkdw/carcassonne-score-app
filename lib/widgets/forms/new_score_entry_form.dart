import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/flat_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/road_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/string_utils.dart' as string_utils;
import '../../utils/colour_utils.dart' as colour_utils;

class NewScoreEntryForm extends StatefulWidget {
  List<String> initiallySelectedPlayers;
  Game game;
  ScoreEntry scoreEntry;
  NewScoreEntryForm({this.initiallySelectedPlayers, this.game, this.scoreEntry}) {
    initiallySelectedPlayers ??= <String>[];
  }

  @override
  _NewScoreEntryFormState createState() => _NewScoreEntryFormState();
}

enum _SelectedScoreEntryType { manual, city, road, cloister, farm }
enum _FormMode { edit, create }

class _NewScoreEntryFormState extends State<NewScoreEntryForm> {
  // -------------------------------------------------------------------------------------------------
  // variables
  // -------------------------------------------------------------------------------------------------

  _SelectedScoreEntryType selectedType;
  _FormMode formMode;

  // for the manual score entry's...
  // ... player selection
  var manualPlayerSelections = <String>[];
  // ... score input
  var manualScoreTextEditingController = TextEditingController();

  // for follower-able structures
  var followerCountMap;

  // for castleable structures' castles
  var castleCountMap;

  // for finish-able structures (cities, roads, cloisters)
  var isStructureFinished;

  // for inn-on-lake and cathedrals
  var hasInnOnLake;
  var hasCathedral;

  var cityNumSegmentsTextEditingController = TextEditingController();
  var cityNumShieldsTextEditingController = TextEditingController();

  var roadNumSegmentsTextEditingController = TextEditingController();

  @override
  void initState() {
    print("initialising state");
    var game = Provider.of<Game>(context, listen: false);
    isStructureFinished = true;
    hasInnOnLake = false;
    hasCathedral = false;
    castleCountMap = Map<String, int>.fromIterables(
      game.players.map((player) => player.name),
      List.generate(game.players.length, (index) => 0),
    );
    followerCountMap = Map<String, int>.fromIterables(
      game.players.map((player) => player.name),
      List.generate(game.players.length, (index) => 0),
    );
    if (widget.initiallySelectedPlayers.isNotEmpty) {
      widget.initiallySelectedPlayers.forEach((playerName) {
        followerCountMap[playerName]++;
      });
    }

    if (widget.scoreEntry == null) {
      print("no ScoreEntry");
      formMode = _FormMode.create;
      selectedType = _SelectedScoreEntryType.manual;
      manualPlayerSelections = widget.initiallySelectedPlayers;
    } else {
      print("found a ScoreEntry");
      formMode = _FormMode.edit;
      switch (widget.scoreEntry.runtimeType) {
        case FlatScoreEntry:
          selectedType = _SelectedScoreEntryType.manual;
          manualPlayerSelections = widget.scoreEntry.scoreMap.keys.toList();
          manualScoreTextEditingController.text = "${widget.scoreEntry.scoreMap.values.first}";
          break;
        default:
          break;
      }
      print(selectedType);
    }
    super.initState();
  }

  void setSelectedType(_SelectedScoreEntryType newType) {
    if (formMode == _FormMode.create) {
      setState(() {
        selectedType = newType;
      });
    } else {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Cannot change type when editing"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  String errorMessage() {
    if (selectedType == _SelectedScoreEntryType.manual) {
      if (!string_utils.isInteger(manualScoreTextEditingController.text)) {
        return 'Enter a valid score.';
      } else if (manualPlayerSelections.isEmpty) {
        return 'Select at least one player.';
      } else {
        return null;
      }
    }
    return null;
  }

  bool isInputAcceptable() => errorMessage() == null;

  void acceptInput() {
    if (!isInputAcceptable()) {
      throw Exception('Trying to accept input when input is not acceptable!');
    }
    ScoreEntry newScoreEntry;
    if (selectedType == _SelectedScoreEntryType.manual) {
      newScoreEntry = FlatScoreEntry(
        playerNames: manualPlayerSelections,
        score: int.parse(manualScoreTextEditingController.text),
      );
    }
    if (selectedType == _SelectedScoreEntryType.city) {
      // TODO
      newScoreEntry = CityScoreEntry(
        followersCount: null,
        numSegments: null,
        numShields: null,
        finished: isStructureFinished,
        castleOwners: List<String>.from(list_utils.countMap2List(castleCountMap)),
        hasCathedral: hasCathedral,
      );
    }
    if (selectedType == _SelectedScoreEntryType.road) {
      // TODO
      newScoreEntry = RoadScoreEntry();
    }
    if (selectedType == _SelectedScoreEntryType.farm) {
      // TODO
    }
    if (selectedType == _SelectedScoreEntryType.cloister) {
      // TODO
    }
    if (newScoreEntry != null) {
      var game = (widget.game ?? Provider.of<Game>(context, listen: false));
      if (formMode == _FormMode.edit) {
        game.removeScoreEntry(widget.scoreEntry);
      }
      game.addScoreEntry(newScoreEntry);
      Provider.of<GamesManager>(context, listen: false).changeMadeSequence();
      Navigator.of(context).pop();
    } else {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Not yet supported'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // variables
    var game = widget.game ?? Provider.of<Game>(context);

    // styles
    var inputDecoration = InputDecoration(
      hintText: 'HINT TEXT',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    // widgets

    // select the ScoreEntry type
    var typeSelector = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MyHeader('Type'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _SelectedScoreEntryType.values
              .map((type) => ChoiceChip(
                    selected: selectedType == type,
                    label: Text(type.toString().split('.').last),
                    onSelected: (_) {
                      setSelectedType(type);
                    },
                  ))
              .toList(),
        )
      ],
    );

    // form for creating a manual score entry
    var manualChildren = <Widget>[
      // enter the score
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: inputDecoration.copyWith(hintText: 'Points'),
        controller: manualScoreTextEditingController,
      ),
      SizedBox(height: 10),
      // select the players
      _MyHeader('Players'),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list_utils.intersperse(
              game.players.map((player) {
                return ChoiceChip(
                  selectedColor: colour_utils.fromText(player.colour),
                  selected: manualPlayerSelections.contains(player.name),
                  label: Text(
                    player.name,
                    style: TextStyle(
                      color: manualPlayerSelections.contains(player.name)
                          ? colour_utils.highContrastColourTo(player.colour)
                          : null,
                    ),
                  ),
                  onSelected: (newValue) {
                    setState(() {
                      if (!manualPlayerSelections.remove(player.name)) {
                        manualPlayerSelections.add(player.name);
                      }
                    });
                  },
                );
              }).toList(),
              () => SizedBox(width: 10)),
        ),
      )
    ];

    // form for followers
    var followerChildren = <Widget>[
      Divider(),
      _MyHeader('Followers'),
      SizedBox(height: 10),
      ...game.players.map((player) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(player.name),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (followerCountMap[player.name] > 0) followerCountMap[player.name]--;
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                Text('${followerCountMap[player.name]}'),
                InkWell(
                  onTap: () {
                    setState(() {
                      followerCountMap[player.name]++;
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ],
            )
          ],
        );
      }).toList(),
    ];

    // form for castles
    var castleChildren = <Widget>[
      Divider(),
      _MyHeader('Castles'),
      SizedBox(height: 10),
      ...game.players.map((player) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(player.name),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (castleCountMap[player.name] > 0) castleCountMap[player.name]--;
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                Text('${castleCountMap[player.name]}'),
                InkWell(
                  onTap: () {
                    setState(() {
                      castleCountMap[player.name]++;
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ],
            )
          ],
        );
      }).toList(),
    ];

    Widget buildCheckboxRow({String text, bool value, Function(bool) onChanged}) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(text),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ]);
    }

    // checkbox for finished/unfinished
    var finishedCheckboxRow = buildCheckboxRow(
      text: 'Finished',
      value: isStructureFinished,
      onChanged: (newVal) => setState(() => isStructureFinished = newVal),
    );

    // form for creating a city
    var cityChildren = <Widget>[
      _MyHeader('Structure'),
      SizedBox(height: 10),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: inputDecoration.copyWith(hintText: 'Num segments'),
        controller: cityNumSegmentsTextEditingController,
      ),
      SizedBox(height: 10),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: inputDecoration.copyWith(hintText: 'Num shields'),
        controller: cityNumShieldsTextEditingController,
      ),
      SizedBox(height: 10),
      finishedCheckboxRow,
      buildCheckboxRow(
        text: 'Has cathedral',
        value: hasCathedral,
        onChanged: (newVal) => setState(() => hasCathedral = newVal),
      ),
      ...followerChildren,
      ...castleChildren,
    ];

    // form for creating a road
    var roadChildren = <Widget>[
      _MyHeader('Structure'),
      SizedBox(height: 10),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: inputDecoration.copyWith(hintText: 'Num segments'),
        controller: roadNumSegmentsTextEditingController,
      ),
      finishedCheckboxRow,
      buildCheckboxRow(
        text: 'Has inn on lake',
        value: hasInnOnLake,
        onChanged: (newVal) => setState(() => hasInnOnLake = newVal)
      ),
      ...followerChildren,
      ...castleChildren,
    ];

    // form for creating a cloister
    var cloisterChildren = <Widget>[Divider(), ...castleChildren];

    // form for creating a farm
    var farmChildren = <Widget>[];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          typeSelector,
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          // use a callback function that uses a switch case to get the correct children
          ...() {
            switch (selectedType) {
              case _SelectedScoreEntryType.manual:
                return manualChildren;
              case _SelectedScoreEntryType.road:
                return roadChildren;
              case _SelectedScoreEntryType.city:
                return cityChildren;
              case _SelectedScoreEntryType.farm:
                return farmChildren;
              case _SelectedScoreEntryType.cloister:
                return cloisterChildren;
              default:
                return manualChildren;
            }
          }(),
          SizedBox(height: 10),
          Center(
            child: FlatButton(
              child: Text('ACCEPT'),
              color: Colors.brown,
              onPressed: () {
                print('Inputs are acceptable: ${isInputAcceptable()}');
                if (isInputAcceptable()) {
                  acceptInput();
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage()),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MyHeader extends StatelessWidget {
  String text;
  _MyHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18),
    );
  }
}
