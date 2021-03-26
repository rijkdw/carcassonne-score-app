import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/screens/new_game_screen.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:carcassonne_score_app/screens/score_explanation_screen.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/player_list_tile.dart';
import 'package:carcassonne_score_app/widgets/list_views/players_list_view.dart';
import 'package:carcassonne_score_app/widgets/list_views/score_entry_list_view.dart';
import 'package:carcassonne_score_app/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/list_utils.dart' as list_utils;
import '../utils/colour_utils.dart' as colour_utils;

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentPageIndex;
  List<String> selectedPlayerNames;

  @override
  void initState() {
    currentPageIndex = 0;
    selectedPlayerNames = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gamesManager = Provider.of<GamesManager>(context);
    var game = Provider.of<Game>(context);
    var page = currentPageIndex == 0
        ? PlayersListView()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Wrap(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: list_utils.intersperse(
                      game.players.map((player) {
                        return ChoiceChip(
                          selectedColor: colour_utils.fromText(player.colour),
                          selected: selectedPlayerNames.contains(player.name),
                          label: Text(
                            player.name,
                            style: TextStyle(
                              color: selectedPlayerNames.contains(player.name)
                                  ? colour_utils.highContrastColourTo(player.colour)
                                  : null,
                            ),
                          ),
                          onSelected: (newValue) {
                            setState(() {
                              if (!selectedPlayerNames.remove(player.name)) {
                                selectedPlayerNames.add(player.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                      () => SizedBox(width: 10)),
                ),
              ),
              Expanded(
                child: ScoreEntryListView(
                  scoreEntries: selectedPlayerNames.isEmpty
                      ? game.scoreEntries
                      : game.getScoreEntriesBenefitting(selectedPlayerNames),
                  textWhenEmpty: selectedPlayerNames.isEmpty
                      ? 'No scored structures to show :(\nTry selecting some players above'
                      : 'No scored structures to show :(\nTry adding some scores for the selected players',
                ),
              ),
            ],
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: selectedPlayerNames.length == 1 && currentPageIndex == 1
            ? colour_utils
                .fromText(game.players.where((player) => player.name == selectedPlayerNames.first).first.colour)
            : null,
        actions: [
          FlatButton.icon(
            label: Text("Score", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider.value(
                  value: game,
                  child: NewScoreEntryScreen(),
                );
              }));
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        unselectedFontSize: 14,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() => currentPageIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            title: Text("Scoreboard"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house_rounded),
            title: Text("Structures"),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: page,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text('Add points'),
      //   icon: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return ChangeNotifierProvider.value(
      //         value: game,
      //         child: NewScoreEntryScreen(),
      //       );
      //     }));
      //   },
      // ),
    );
  }
}
