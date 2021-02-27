import 'package:carcassonne_score_app/dialogs/list_dialog.dart';
import 'package:carcassonne_score_app/dialogs/yes_no_dialog.dart';
import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/list_utils.dart' as list_utils;
import '../utils/colour_utils.dart' as colour_utils;


class ScoreExplanationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Player player;
    try {
      player = Provider.of<Player>(context);
    } catch (e) {}
    var game = Provider.of<Game>(context);
    var scoreEntries = player == null ? game.scoreEntries : game.getScoreEntriesBenefitting(player.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('${game.name} > ${player == null ? "Scores" : player.name}'),
        backgroundColor: player == null ? null : colour_utils.fromText(player.colour),
      ),
      body: scoreEntries.isEmpty
          ? Center(
              child: Text('No points :('),
            )
          : ListView(
              children: scoreEntries.map((scoreEntry) {
                return Provider.value(
                  value: scoreEntry,
                  child: _ScoreExplanationListTile(),
                );
              }).toList(),
            ),
    );
  }
}

class _ScoreExplanationListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scoreEntry = Provider.of<ScoreEntry>(context);
    var game = Provider.of<Game>(context);
    var gamesManager = Provider.of<GamesManager>(context);

    var circleAvatars = scoreEntry.scoreMap.keys.map((name) {
      var player = game.players.where((player) => player.name == name).first;
      try {
        var providerPlayer = Provider.of<Player>(context);
        if (providerPlayer.name != name) {
          return null;
        }
      } catch (e) {}
      return CircleAvatar(
        child: Text(
          "${scoreEntry.scoreMap[name]}",
          style: TextStyle(color: colour_utils.highContrastColourTo(player.colour), fontSize: 20),
        ),
        backgroundColor: colour_utils.fromText(player.colour),
      );
    }).toList();
    circleAvatars.remove(null);

    return ExpansionTile(
      title: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: list_utils.intersperse(
                  circleAvatars,
                  () => SizedBox(width: 2),
                ),
              ),
              SizedBox(width: 6),
              Text(scoreEntry.properName),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                var dialog = ListDialog(
                  title: "${scoreEntry.properName}",
                  listItems: [
                    ListItem(
                      text: "Edit",
                      iconData: Icons.edit,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return NewScoreEntryScreen(
                            game: game,
                            scoreEntry: scoreEntry,
                          );
                        }));
                      },
                    ),
                    ListItem(
                      text: "Delete",
                      iconData: Icons.delete,
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return YesNoDialog(
                              title: "Delete the ScoreEntry?",
                              onYes: () {
                                game.removeScoreEntry(scoreEntry);
                                gamesManager.changeMadeSequence();
                              },
                              onNo: () {},
                            );
                          },
                        );
                      },
                    )
                  ],
                );
                return MultiProvider(
                  providers: [
                    Provider.value(value: scoreEntry),
                    ChangeNotifierProvider.value(value: game),
                  ],
                  child: dialog,
                );
              });
        },
      ),
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      children: [
        Text(scoreEntry.toString()),
      ],
    );

    return ListTile(
      title: Text(scoreEntry.toString()),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => YesNoDialog(
                title: "Delete ScoreEntry?",
                onYes: () {
                  game.removeScoreEntry(scoreEntry);
                  gamesManager.changeMadeSequence();
                },
                onNo: () {}),
          );
        },
      ),
    );
  }
}
