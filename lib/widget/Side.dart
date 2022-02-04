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
    /**if (cube.getlight(index)){
      return GestureDetector(
          behavior:HitTestBehavior.opaque,
        onTap: () {
          print("pressed");

        },
        onTapDown: (detail){
          Provider.of<gameProvider>(context,listen:false).move(cube);
          print("tapdown");
        },
        child: sideContent(number,cube.getlight(index)),
      );
    }else{
      return sideContent(number,cube.getlight(index));
    }**/
    return sideContent(number,cube.getlight(index));
  }
}

Widget sideContent(int number, bool enlight){
  return Container(
    width: cubesize,
    height: cubesize,
    decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        border: Border.all(color: black)
    ),
    child: Center(
      child: Text(
        number.toString(),
        style: TextStyle(fontSize: 14,color: enlight?Colors.green:Colors.grey),
      ),
    ),
  );
}