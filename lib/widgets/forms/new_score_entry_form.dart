import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/flat_score_entry.dart';
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

  @override
  void initState() {
    print("initialising state");
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
    }
    if (selectedType == _SelectedScoreEntryType.road) {
      // TODO
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

    // form for creating a city
    var cityChildren = <Widget>[];

    // form for creating a cloister
    var cloisterChildren = <Widget>[];

    // form for creating a road
    var roadChildren = <Widget>[];

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
