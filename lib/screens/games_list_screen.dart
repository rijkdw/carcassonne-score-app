import 'package:carcassonne_score_app/screens/new_game_screen.dart';
import 'package:carcassonne_score_app/widgets/list_views/games_list_view.dart';
import 'package:flutter/material.dart';

class GamesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: GamesListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewGameScreen();
          }));
        },
      ),
    );
  }
}
