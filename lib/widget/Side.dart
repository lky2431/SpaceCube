import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:threedslidepuzzle/model/gameProvider.dart';

import '../const.dart';

class Side extends StatelessWidget {
  const Side({required this.number, required this.cube, required this.index,required this.cubesize});

  final int number;
  final cubeModel cube;
  final int index;
  final double cubesize;
  @override
  Widget build(BuildContext context) {
    return sideContent(number, cube.getlight(index),cubesize);
  }
}

Widget sideContent(int number, bool enlight,double cubesize) {

  return Container(
    width: cubesize,
    height: cubesize,
    decoration: BoxDecoration(
        gradient:
            RadialGradient(colors: [Color(0xff000022), Color(0xff000033)]),
        border: Border.all(color: black)),
    child: Center(
      child: Text(
        number.toString(),
        style: TextStyle(
            fontSize: cubesize/4,
            shadows: [if(enlight)Shadow(blurRadius: 16.0)],
            color: enlight ? oncolor : offcolor),
      ),
    ),
  );
}
