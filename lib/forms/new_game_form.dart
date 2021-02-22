import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/colour_utils.dart' as colour_utils;
import '../utils/bool_utils.dart' as bool_utils;
import '../utils/list_utils.dart' as list_utils;

class NewGameForm extends StatefulWidget {
  @override
  _NewGameFormState createState() => _NewGameFormState();
}

class _NewGameFormState extends State<NewGameForm> {
  var formKey = GlobalKey();
  var gameNameTextEditingController = TextEditingController();
  var playerNameTextEditingControllers = List.generate(6, (index) => TextEditingController());

  var colours = ['Red', 'Blue', 'Yellow', 'Green', 'Gray', 'Black'];

  bool hasEnoughPlayers() {
    return list_utils.count(playerNameTextEditingControllers.map((c) => c.text.isNotEmpty).toList(), true) >= 2;
  }

  bool hasGameName() => gameNameTextEditingController.text.isNotEmpty;

  void acceptInputs() {
    var playerNames = <String>[];
    var playerColours = <String>[];
    for (var i = 0; i < 6; i++) {
      if (playerNameTextEditingControllers[i].text.isNotEmpty) {
        playerNames.add(playerNameTextEditingControllers[i].text);
        playerColours.add(colours[i]);
      }
    }
    var newGame = Game(
      name: gameNameTextEditingController.text,
      playerNames: playerNames,
      playerColours: playerColours,
    );
    Provider.of<GamesManager>(context, listen: false).addNewGame(newGame);
    Navigator.of(context).pop();
  }

  void reportErroneousInputs() {
    String message;
    if (!hasGameName()) {
      message = 'Enter a game name.';
    } else if (!hasEnoughPlayers()) {
      message = 'Can\'t play with less than two players.';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var fieldDecoration = InputDecoration(
      hintText: 'HINT TEXT',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    var gameNameFieldDecoration = fieldDecoration.copyWith(
      hintText: 'Game name',
      hintStyle: TextStyle(fontSize: 20),
    );

    var playerNameFieldDecoration = fieldDecoration.copyWith(
      hintText: 'Player name',
      hintStyle: TextStyle(fontSize: 16),
    );

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: gameNameTextEditingController,
              textCapitalization: TextCapitalization.words,
              decoration: gameNameFieldDecoration,
            ),
            SizedBox(height: 10),
            ...List.generate(6, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: colour_utils.fromText(colours[index]),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        decoration: playerNameFieldDecoration,
                        textCapitalization: TextCapitalization.words,
                        controller: playerNameTextEditingControllers[index],
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
            FlatButton(
              child: Text('ACCEPT'),
              onPressed: () {
                if (hasGameName() && hasEnoughPlayers()) {
                  acceptInputs();
                } else {
                  reportErroneousInputs();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
