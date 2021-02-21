import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/flat_score_entry.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/list_utils.dart' as list_utils;
import '../utils/string_utils.dart' as string_utils;

class NewScoreEntryForm extends StatefulWidget {
  @override
  _NewScoreEntryFormState createState() => _NewScoreEntryFormState();
}

enum _SelectedScoreEntryType { manual, city, road, cloister, farm }

class _NewScoreEntryFormState extends State<NewScoreEntryForm> {
  // -------------------------------------------------------------------------------------------------
  // variables
  // -------------------------------------------------------------------------------------------------

  _SelectedScoreEntryType selectedType = _SelectedScoreEntryType.manual;

  // for the manual score entry's...
  // ... player selection
  var manualPlayerSelections = <String>[];
  // ... score input
  var manualScoreTextEditingController = TextEditingController();

  void setSelectedType(_SelectedScoreEntryType newType) {
    setState(() {
      selectedType = newType;
    });
  }

  String returnErrorMessage() {
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

  bool isInputAcceptable() => returnErrorMessage() == null;

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
    Provider.of<Game>(context, listen: false).addScoreEntry(newScoreEntry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // variables
    var game = Provider.of<Game>(context);

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
              game.playerNames.map((name) {
                return ChoiceChip(
                  selected: manualPlayerSelections.contains(name),
                  label: Text(name),
                  onSelected: (newValue) {
                    setState(() {
                      if (!manualPlayerSelections.remove(name)) {
                        manualPlayerSelections.add(name);
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
              onPressed: () {
                print('Inputs are acceptable: ${isInputAcceptable()}');
                if (isInputAcceptable()) {
                  acceptInput();
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(returnErrorMessage()),
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
