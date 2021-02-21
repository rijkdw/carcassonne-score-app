import 'package:carcassonne_score_app/objects/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NewScoreEntryForm extends StatefulWidget {
  @override
  _NewScoreEntryFormState createState() => _NewScoreEntryFormState();
}

enum _SelectedScoreEntryType { manual, city, road, cloister, farm }

class _NewScoreEntryFormState extends State<NewScoreEntryForm> {
  _SelectedScoreEntryType selectedType;

  @override
  void initState() {
    selectedType = _SelectedScoreEntryType.manual;
    super.initState();
  }

  void setSelectedType(_SelectedScoreEntryType newType) {
    setState(() {
      selectedType = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // styles
    // -------------------------------------------------------------------------------------------------

    var inputDecoration = InputDecoration(
      hintText: 'HINT TEXT',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    // -------------------------------------------------------------------------------------------------
    // widgets
    // -------------------------------------------------------------------------------------------------

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
      TextFormField(decoration: inputDecoration.copyWith(hintText: 'Points')),
      SizedBox(height: 10),
      _MyHeader('Players'),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: Provider.of<Game>(context).playerNames.map((name) {
          return Chip(
            label: Text(name),
          );
        }).toList(),
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
