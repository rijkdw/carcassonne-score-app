import 'dart:convert';

import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/screens/games_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
  SharedPreferences.getInstance().then((prefs) {
    prefs.setString('_GAMES_KEY', jsonEncode([]));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GamesManager())],
      child: MaterialApp(
          title: 'Carcassonne Score Tracker',
          theme: ThemeData(
              primarySwatch: Colors.brown,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              chipTheme: ChipThemeData(
                selectedColor: Colors.brown[400],
                secondarySelectedColor: Colors.brown[400],
                backgroundColor: Colors.brown[200],
                disabledColor: Colors.green,
                brightness: Brightness.light,
                padding: EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                secondaryLabelStyle: TextStyle(),
                labelStyle: TextStyle(),
              )),
          home: GamesListScreen()),
    );
  }
}
