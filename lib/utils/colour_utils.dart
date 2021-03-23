import 'package:flutter/material.dart';


Color fromText(String colourName) {
  colourName = colourName.toLowerCase();
  var colourMap = {
    "red": Colors.red,
    "blue": Colors.blue,
    "green": Colors.green,
    "yellow": Colors.yellow,
    "grey": Colors.grey,
    "gray": Colors.grey,
    "black": Colors.black
  };
  return colourMap[colourName];
}

Color fromTextDull(String colourName) {
  colourName = colourName.toLowerCase();
  var dullColourMap = {
    "red": Colors.red[200],
    "blue": Colors.blue[200],
    "green": Colors.green[200],
    "yellow": Colors.yellow[200],
    "grey": Colors.grey[300],
    "gray": Colors.grey[300],
    "black": Colors.grey[600],
  };
  return dullColourMap[colourName];
}

Color highContrastColourTo(String colourName) {
  var highContrastColourMap = {
    "red": Colors.white,
    "blue": Colors.white,
    "green": Colors.white,
    "yellow": Colors.black,
    "gray": Colors.white,
    "grey": Colors.white,
    "black": Colors.white,
  };
  return highContrastColourMap[colourName];
}