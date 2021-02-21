import 'package:carcassonne_score_app/forms/new_score_entry_form.dart';
import 'package:flutter/material.dart';

class NewScoreEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Score Entry'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: NewScoreEntryForm(),
      ),
    );
  }
}