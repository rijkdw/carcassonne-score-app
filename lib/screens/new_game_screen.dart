import 'package:carcassonne_score_app/managers/previous_players_manager.dart';
import 'package:flutter/material.dart';
import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/colour_utils.dart' as colour_utils;
import '../utils/bool_utils.dart' as bool_utils;
import '../utils/list_utils.dart' as list_utils;

class NewGameScreen extends StatefulWidget {
  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  var formKey = GlobalKey();
  var gameNameTextEditingController = TextEditingController();
  var playerNameTextEditingControllers = List.generate(6, (index) => TextEditingController());

  var colours = ['Red', 'Blue', 'Yellow', 'Green', 'Gray', 'Black'];

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void trimTextEditingControllers() {
    playerNameTextEditingControllers.forEach((c) => c.text = c.text.trim());
  }

  bool hasEnoughPlayers() {
    return list_utils.count(playerNameTextEditingControllers.map((c) => c.text.trim().isNotEmpty).toList(), true) >= 2;
  }

  bool hasDuplicatePlayerNames() {
    var nonEmptyNames = <String>[];
    playerNameTextEditingControllers.forEach((c) {
      if (c.text.trim().isNotEmpty) nonEmptyNames.add(c.text.trim());
    });
    return list_utils.containsDuplicates(nonEmptyNames);
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
    playerNames.forEach(Provider.of<PreviousPlayersManager>(context, listen: false).addToNames);
    Navigator.of(context).pop();
  }

  void reportErroneousInputs() {
    String message;
    if (!hasGameName()) {
      message = 'Enter a game name.';
    } else if (!hasEnoughPlayers()) {
      message = 'Can\'t play with less than two players.';
    } else if (hasDuplicatePlayerNames()) {
      message = 'Can\'t have duplicate player names.';
    }
    scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void acceptSequence() {
    trimTextEditingControllers();
    if (hasGameName() && hasEnoughPlayers() && !hasDuplicatePlayerNames()) {
      acceptInputs();
    } else {
      reportErroneousInputs();
    }
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

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('New Game'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: acceptSequence,
            icon: Icon(Icons.check),
            label: Text('Done'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
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
                        SizedBox(width: 10),
                        CircleAvatar(
                          // if no player yet, dull the CircleAvatar
                          backgroundColor: playerNameTextEditingControllers[index].text.isEmpty
                              ? colour_utils.fromTextDull(colours[index])
                              : colour_utils.fromText(colours[index]),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            decoration: playerNameFieldDecoration,
                            textCapitalization: TextCapitalization.words,
                            controller: playerNameTextEditingControllers[index],
                            onChanged: (newText) {
                              // update state to make CircleAvatars "light up"
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // SizedBox(height: 20),
                // FlatButton(
                //   child: Text('ACCEPT'),
                //   onPressed: acceptSequence,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
