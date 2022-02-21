import 'dart:ui';

import 'package:flutter/material.dart';

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
Color oncolor=Colors.yellow;
Color offcolor=Color(0xFF5A541B);


bool debug=false;
printd(String content){
  if(debug)print(content);
}