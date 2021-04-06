import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/cloister_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/farm_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/flat_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/road_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:carcassonne_score_app/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/string_utils.dart' as string_utils;
import '../../utils/colour_utils.dart' as colour_utils;
import '../../utils/bool_utils.dart' as bool_utils;

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
  Map<String, int> followerCountMap;

  // for castleable structures' castles
  Map<String, int> castleCountMap;

  // for finish-able structures (cities, roads, cloisters)
  var isStructureFinished;

  // for inn-on-lake, cathedrals, barns
  bool hasInnOnLake;
  bool hasCathedral;
  bool hasBarn;

  // for cities
  var cityNumSegmentsTextEditingController = TextEditingController();
  var cityNumShieldsTextEditingController = TextEditingController();

  // for roads
  var roadNumSegmentsTextEditingController = TextEditingController();

  // for cloisters
  var cloisterNumTilesTextEditingController = TextEditingController();

  // for farms
  var farmNumCitiesTextEditingController = TextEditingController();
  var farmNumCastlesTextEditingController = TextEditingController();

  @override
  void initState() {
    print("initialising state");
    var game = Provider.of<Game>(context, listen: false);
    isStructureFinished = true;
    hasInnOnLake = false;
    hasCathedral = false;
    hasBarn = false;
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
    // NOTE return null if no error
    // manual
    if (selectedType == _SelectedScoreEntryType.manual) {
      // A valid score must be given.
      if (!string_utils.isInteger(manualScoreTextEditingController.text)) {
        return 'Enter a valid score.';
      }
      // At least one player must be selected.
      if (manualPlayerSelections.isEmpty) {
        return 'Select at least one player.';
      }
      return null;
    }
    // follower-based
    if (selectedType != _SelectedScoreEntryType.manual) {
      // There must be a follower on the structure.
      if (!bool_utils.any(followerCountMap.values.map((count) => count > 0).toList())) {
        return 'At least one follower must be placed to score.';
      }
    }
    // road
    if (selectedType == _SelectedScoreEntryType.road) {
      // A valid number of road segments must be entered.
      if (!string_utils.isNonNegativeInteger(roadNumSegmentsTextEditingController.text)) {
        return 'Enter a valid number of road segments.';
      }
    }
    // city
    if (selectedType == _SelectedScoreEntryType.city) {
      var numSegStr = cityNumSegmentsTextEditingController.text;
      var numShieldStr = cityNumShieldsTextEditingController.text;
      // A valid number of city segments must be entered.
      if (!string_utils.isNonNegativeInteger(numSegStr)) {
        return 'Enter a valid number of city segments.';
      }
      // A valid number of shields, or no text at all.
      if (!string_utils.isNonNegativeInteger(numShieldStr) && numShieldStr.isNotEmpty) {
        return 'Enter a valid number of shields.';
      }
      return null;
    }
    // farm
    if (selectedType == _SelectedScoreEntryType.farm) {
      // Either A) a valid number of cities or B) a valid number of castles
      if (string_utils.isNonNegativeInteger(farmNumCitiesTextEditingController.text) ||
          string_utils.isNonNegativeInteger(farmNumCastlesTextEditingController.text)) {
        return null;
      }
      return 'Enter a valid number of cities or farms.';
    }
    // cloister
    if (selectedType == _SelectedScoreEntryType.cloister) {
      // Must have valid number of tiles input
      if (!string_utils.isNonNegativeInteger(cloisterNumTilesTextEditingController.text)) {
        return 'Enter a valid number of tiles.';
      }
      if (int.parse(cloisterNumTilesTextEditingController.text) > 8) {
        return 'A cloister tile cannot be surrounded by more than 8 tiles.';
      }
      return null;
    }
    return null;
  }

  bool isInputAcceptable() {
    /// Are the given inputs acceptable?
    return errorMessage() == null;
  }

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
      newScoreEntry = CityScoreEntry(
        followersCount: followerCountMap,
        castleOwners: castleCountMap,
        numSegments: int.parse(cityNumSegmentsTextEditingController.text),
        numShields:
            cityNumShieldsTextEditingController.text.isEmpty ? 0 : int.parse(cityNumShieldsTextEditingController.text),
        finished: isStructureFinished,
        hasCathedral: hasCathedral,
      );
    }
    if (selectedType == _SelectedScoreEntryType.road) {
      newScoreEntry = RoadScoreEntry(
        followersCount: followerCountMap,
        castleOwners: castleCountMap,
        numSegments: int.parse(roadNumSegmentsTextEditingController.text),
        finished: isStructureFinished,
        hasInnOnLake: hasInnOnLake,
      );
    }
    if (selectedType == _SelectedScoreEntryType.farm) {
      newScoreEntry = FarmScoreEntry(
        followersCount: followerCountMap,
        hasBarn: hasBarn,
        numCities:
            farmNumCitiesTextEditingController.text.isEmpty ? 0 : int.parse(farmNumCitiesTextEditingController.text),
        numCastles:
            farmNumCastlesTextEditingController.text.isEmpty ? 0 : int.parse(farmNumCastlesTextEditingController.text),
      );
    }
    if (selectedType == _SelectedScoreEntryType.cloister) {
      newScoreEntry = CloisterScoreEntry(
        numTiles: int.parse(cloisterNumTilesTextEditingController.text),
        castleOwners: castleCountMap,
      );
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

    Widget buildDecoratedTextFormField(
        {String hintText: 'HINT TEXT', TextEditingController controller, IconData iconData}) {
      return Row(
        children: [
          Icon(iconData, color: Colors.brown, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: inputDecoration.copyWith(hintText: hintText),
              controller: controller,
            ),
          ),
        ],
      );
    }

    // form for creating a manual score entry
    var manualChildren = <Widget>[
      // enter the score
      _MyHeader('Details'),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Points',
        controller: manualScoreTextEditingController,
        iconData: Icons.stars,
      ),
      SizedBox(height: 10),
      // select the players
      _MyHeader('Players'),
      Wrap(
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
      )
    ];

    // player info, minus-icon, value, plus-icon
    Widget buildPlayerRow({Player player, VoidCallback onPlus, VoidCallback onMinus, String text}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                player.name,
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onMinus();
                    },
                    child: Icon(Icons.arrow_left_rounded, size: 30),
                  ),
                  CircleAvatar(
                    backgroundColor:
                        text == '0' ? colour_utils.fromTextDull(player.colour) : colour_utils.fromText(player.colour),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color: colour_utils.highContrastColourTo(player.colour),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onPlus();
                    },
                    child: Icon(Icons.arrow_right_rounded, size: 30),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 4),
        ],
      );
    }

    var players = game.players;
    players.sort((a, b) => a.name.compareTo(b.name));

    // form for followers
    var followerChildren = <Widget>[
      Divider(),
      SizedBox(height: 10),
      _MyHeader('Followers'),
      SizedBox(height: 10),
      ...players.map((player) {
        return buildPlayerRow(
          player: player,
          text: '${followerCountMap[player.name]}',
          onPlus: () => setState(() => followerCountMap[player.name]++),
          onMinus: () => setState(() {
            if (followerCountMap[player.name] > 0) followerCountMap[player.name]--;
          }),
        );
      }).toList(),
      SizedBox(height: 10),
    ];

    // form for castles
    var castleChildren = <Widget>[
      Divider(),
      SizedBox(height: 10),
      _MyHeader('Castles'),
      SizedBox(height: 10),
      ...players.map((player) {
        return buildPlayerRow(
          player: player,
          text: '${castleCountMap[player.name]}',
          onPlus: () => setState(() => castleCountMap[player.name]++),
          onMinus: () => setState(() {
            if (castleCountMap[player.name] > 0) castleCountMap[player.name]--;
          }),
        );
      }).toList(),
      SizedBox(height: 10),
    ];

    Widget buildCheckboxRow({String text, bool value, Function(bool) onChanged}) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
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
      _MyHeader('Details'),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Number of city segments',
        iconData: Icons.circle,
        controller: cityNumSegmentsTextEditingController,
      ),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Number of shields',
        iconData: Icons.security_rounded,
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
      _MyHeader('Details'),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Number of road segments',
        iconData: Icons.circle,
        controller: roadNumSegmentsTextEditingController,
      ),
      SizedBox(height: 10),
      finishedCheckboxRow,
      buildCheckboxRow(
        text: 'Has inn on lake',
        value: hasInnOnLake,
        onChanged: (newVal) => setState(() => hasInnOnLake = newVal),
      ),
      ...followerChildren,
      ...castleChildren,
    ];

    // form for creating a cloister
    var cloisterChildren = <Widget>[
      _MyHeader('Details'),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Number of tiles surrounding',
        iconData: Icons.grid_on_rounded,
        controller: cloisterNumTilesTextEditingController,
      ),
      SizedBox(height: 10),
      ...followerChildren,
      ...castleChildren,
    ];

    // form for creating a farm
    var farmChildren = <Widget>[
      _MyHeader('Details'),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Number of cities',
        iconData: Icons.circle,
        controller: farmNumCitiesTextEditingController,
      ),
      SizedBox(height: 10),
      buildDecoratedTextFormField(
        hintText: 'Number of castles',
        iconData: Icons.circle,
        controller: farmNumCastlesTextEditingController,
      ),
      SizedBox(height: 10),
      buildCheckboxRow(
        text: 'Has barn',
        value: hasBarn,
        onChanged: (newVal) => setState(() => hasBarn = newVal),
      ),
      SizedBox(height: 10),
      ...followerChildren,
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
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
          ),
          SizedBox(height: 20),
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
      style: TextStyle(fontSize: 20),
    );
  }
}
