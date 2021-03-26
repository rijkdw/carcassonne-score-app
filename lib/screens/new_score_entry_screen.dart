import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:carcassonne_score_app/widgets/forms/new_score_entry_form.dart';
import 'package:flutter/material.dart';


enum _FormMode { edit, create }

class NewScoreEntryScreen extends StatelessWidget {

  List<String> initiallySelectedPlayers;
  Game game;
  ScoreEntry scoreEntry;
  _FormMode formMode;

  NewScoreEntryScreen({this.initiallySelectedPlayers, this.game, this.scoreEntry}) {
    this.initiallySelectedPlayers ??= <String>[];
    this.formMode = this.scoreEntry == null ? _FormMode.create : _FormMode.edit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formMode == _FormMode.create ? 'New Score Entry' : 'Edit Score Entry'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: NewScoreEntryForm(
          game: this.game,
          scoreEntry: this.scoreEntry,
          initiallySelectedPlayers: this.initiallySelectedPlayers,
        ),
      ),
    );
  }
}
