import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:threedslidepuzzle/model/gameProvider.dart';
import 'package:vector_math/vector_math_64.dart';

import '../const.dart';
import 'Side.dart';

class OneCube extends StatelessWidget {
  OneCube(
      {

      required this.cube,
      required this.numbers,
        required this.cubesize
      });


  final cubeModel cube;
  final List<int> numbers;
  final double cubesize;
  late List<List<dynamic>> facetransformationMatrix;



  List<Widget> arrangeFace() {
    List<Widget> faces = [];
    for (int k=0;k<3;k++){
      List<dynamic> transformdetail=facetransformationMatrix[numbers[k+3]];
      faces.add(
        Transform(
          transform: Matrix4.identity()
            ..rotateX(transformdetail[0])
            ..rotateY(transformdetail[1])
            ..translate(transformdetail[2], transformdetail[3], transformdetail[4]),
          alignment: transformdetail[5],
          child: Side(number: cube.face(numbers[k+3]+1),cube: cube,index:numbers[k+3]+1, cubesize: cubesize,),
        ),
      );
    }
    return faces.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    double cubesize=Provider.of<gameProvider>(context,listen: false).cubesize;
    facetransformationMatrix=
    [
      [-pi/2,0.0,0.0,-cubesize / 2,0.0,FractionalOffset.topCenter],
      [0.0,pi/2,-cubesize / 2,0.0,0.0,FractionalOffset.centerLeft],
      [0.0,0.0,0.0,0.0,-cubesize / 2,FractionalOffset.center],
      [0.0,-pi/2,cubesize / 2,0.0,0.0,FractionalOffset.centerRight],
      [pi/2,0.0,0.0,cubesize / 2,0.0,FractionalOffset.bottomCenter],
      [0.0,pi,0.0,0.0,-cubesize / 2,FractionalOffset.center],
    ];

    return Center(
      child: Container(
        height: cubesize,
        width: cubesize,
        color: black,
        child: Stack(children: arrangeFace()),
      ),
    );
  }
}
