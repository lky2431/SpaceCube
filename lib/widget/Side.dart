import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:threedslidepuzzle/model/gameProvider.dart';

import '../const.dart';

class Side extends StatelessWidget {
  const Side({required this.number,required this.cube,required this.index});

  final int number;
  final cubeModel cube;
  final int index;
  @override
  Widget build(BuildContext context) {
    return sideContent(number,cube.getlight(index));
  }
}

Widget sideContent(int number, bool enlight){
  return Container(
    width: cubesize,
    height: cubesize,
    decoration: BoxDecoration(
        gradient: RadialGradient(colors: [Color(0xff000022),Color(0xff000033)]

        ),
        border: Border.all(color: black)
    ),
    child: Center(
      child: Text(
        number.toString(),
        style: TextStyle(fontSize: 24,color: enlight?oncolor:offcolor),
      ),
    ),
  );
}