import 'package:carcassonne_score_app/dialogs/list_dialog.dart';
import 'package:carcassonne_score_app/dialogs/yes_no_dialog.dart';
import 'package:carcassonne_score_app/managers/games_manager.dart';
import 'package:carcassonne_score_app/objects/game.dart';
import 'package:carcassonne_score_app/objects/player.dart';
import 'package:carcassonne_score_app/objects/score_entries/score_entry.dart';
import 'package:carcassonne_score_app/screens/new_score_entry_screen.dart';
import 'package:carcassonne_score_app/widgets/list_views/score_entry_list_view.dart';
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
      body: ScoreEntryListView(
        scoreEntries: scoreEntries,
      ),
    );
  }
}