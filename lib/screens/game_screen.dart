import 'package:carcassonne_score_app/objects/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = Provider.of<Game>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
    );
  }
}
