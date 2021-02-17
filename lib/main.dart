import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/screens/games_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GamesManager())
      ],
      child: MaterialApp(
        title: 'Carcassonne Score Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: GamesListScreen()
      ),
    );
  }
}