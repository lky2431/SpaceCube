import 'dart:ui';

import 'package:flutter/material.dart';

const double cubesize=100;
List<Color> cubeColor=[
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.brown,
  Colors.grey,
];

Color black=Colors.black;
Color colorless=Colors.transparent;

bool debug=false;
printd(String content){
  if(debug)print(content);
}