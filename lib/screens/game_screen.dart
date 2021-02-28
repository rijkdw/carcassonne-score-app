import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/objects/score_entries/city_score_entry.dart';
import 'package:carcassonne_score_app/screens/new_game_screen.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:carcassonne_score_app/screens/score_explanation_screen.dart';
import 'package:carcassonne_score_app/widgets/list_tiles/player_list_tile.dart';
import 'package:carcassonne_score_app/widgets/list_views/players_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentPageIndex;
  List<Widget> pages = [PlayersListView()];

  @override
  void initState() {
    currentPageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gamesManager = Provider.of<GamesManager>(context);
    var game = Provider.of<Game>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        actions: [
          IconButton(
            icon: Icon(Icons.remove_red_eye_rounded),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider.value(
                  value: game,
                  child: ScoreExplanationScreen(),
                );
              }));
            },
          )
        ],
      ),
      // body: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //   child: PlayersListView(),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() => currentPageIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            title: Text("Players"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score_rounded),
            title: Text("Scores"),
          )
        ],
      ),
      body: pages[currentPageIndex],
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add points'),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider.value(
              value: game,
              child: NewScoreEntryScreen(),
            );
          }));
        },
      ),
    );
  }
}
