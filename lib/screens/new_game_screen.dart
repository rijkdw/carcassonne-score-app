import 'package:carcassonne_score_app/forms/new_game_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Game'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: NewGameForm(),
      ),
    );
  }
}
