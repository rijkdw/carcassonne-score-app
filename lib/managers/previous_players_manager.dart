import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousPlayersManager extends ChangeNotifier {

  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------

  List<String> previousPlayerNames = [];

  // -------------------------------------------------------------------------------------------------
  // methods
  // -------------------------------------------------------------------------------------------------

  void addToNames(String name) {
    if (!previousPlayerNames.contains(name)) {
      previousPlayerNames.add(name);
      storeInLocal();
      notifyListeners();
    }
  }

  void addDummyNames() {
    previousPlayerNames.addAll(['Rijk', 'Liza', 'March']);
    storeInLocal();
    notifyListeners();
  }

  void deleteName(String name) {
    previousPlayerNames.remove(name);
    storeInLocal();
    notifyListeners();
  }

  // -------------------------------------------------------------------------------------------------
  // storage
  // -------------------------------------------------------------------------------------------------

  static const _PLAYERNAMES_KEY = 'playernames';

  void loadFromLocal() async {
    var prefs = await SharedPreferences.getInstance();
    previousPlayerNames = List<String>.from(jsonDecode(prefs.getString(_PLAYERNAMES_KEY)));
    notifyListeners();
  }

  void storeInLocal() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_PLAYERNAMES_KEY, jsonEncode(previousPlayerNames));
  }

}