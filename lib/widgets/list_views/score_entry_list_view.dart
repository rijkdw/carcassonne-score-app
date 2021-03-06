import 'package:carcassonne_score_app/dialogs/list_dialog.dart';
import 'package:carcassonne_score_app/dialogs/yes_no_dialog.dart';
import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/list_utils.dart' as list_utils;
import '../../utils/colour_utils.dart' as colour_utils;
import '../../utils/datetime_utils.dart' as datetime_utils;

enum ScoreEntryListTileSize { big, small }

class ScoreEntryListView extends StatelessWidget {
  List<ScoreEntry> scoreEntries;
  ScoreEntryListTileSize tileSize;
  String textWhenEmpty;

  ScoreEntryListView(
      {this.scoreEntries, this.tileSize = ScoreEntryListTileSize.big, this.textWhenEmpty = 'No structures.'}) {
    this.scoreEntries ??= <ScoreEntry>[];
  }

  @override
  Widget build(BuildContext context) {
    return scoreEntries.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.house_rounded, size: 100, color: Colors.brown[200]),
                Text(
                  this.textWhenEmpty,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView(
            children: scoreEntries.map((scoreEntry) {
              return Provider.value(
                value: scoreEntry,
                child: _ScoreExplanationListTile(),
              );
            }).toList(),
          );
  }
}

class _ScoreExplanationListTile extends StatelessWidget {
  ScoreEntryListTileSize tileSize;
  _ScoreExplanationListTile({this.tileSize = ScoreEntryListTileSize.big});

  @override
  Widget build(BuildContext context) {
    var scoreEntry = Provider.of<ScoreEntry>(context);
    var game = Provider.of<Game>(context);
    var gamesManager = Provider.of<GamesManager>(context);

    var keys = <String>[];
    for (String name in scoreEntry.scoreMap.keys) {
      if (scoreEntry.scoreMap[name] > 0) keys.add(name);
    }
    keys.sort((a, b) => a.compareTo(b));
    var circleAvatars = keys.map((name) {
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
          style: TextStyle(
            color: colour_utils.highContrastColourTo(player.colour),
            fontSize: tileSize == ScoreEntryListTileSize.big ? 20 : 16,
          ),
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
              SizedBox(width: 12),
              Text("${scoreEntry.properName}"),
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
                    // TODO figure out the fucking provider kak
                    // ListItem(
                    //   text: "Edit",
                    //   iconData: Icons.edit,
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    //       return NewScoreEntryScreen(
                    //         game: game,
                    //         scoreEntry: scoreEntry,
                    //       );
                    //     }));
                    //   },
                    // ),
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
