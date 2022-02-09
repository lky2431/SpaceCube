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
      required this.numbers});


  final cubeModel cube;
  final List<int> numbers;

  bool seeid=false;
  static double d = cubesize / 2;

  static List<List<dynamic>> facetransformationMatrix=
  [
    [-pi/2,0.0,0.0,-d,0.0,FractionalOffset.topCenter],
    [0.0,pi/2,-d,0.0,0.0,FractionalOffset.centerLeft],
    [0.0,0.0,0.0,0.0,-d,FractionalOffset.center],
    [0.0,-pi/2,d,0.0,0.0,FractionalOffset.centerRight],
    [pi/2,0.0,0.0,d,0.0,FractionalOffset.bottomCenter],
    [0.0,pi,0.0,0.0,-d,FractionalOffset.center],
  ];


  List<Widget> arrangeFace() {
    /**List<Widget> rawfaces = [
      Transform(
        transform: Matrix4.identity()
          ..rotateX(-pi / 2)
          ..translate(0.0, -cubesize / 2, 0.0),
        alignment: FractionalOffset.topCenter,
        child: Side(number:seeid?cube.id:cube.face(1),cube: cube,index:1),
      ),
      Transform(
        transform: Matrix4.identity()
          ..rotateY(pi / 2)
          ..translate(-cubesize / 2, 0.0,0.0 ),
        alignment: FractionalOffset.centerLeft,
        child: Side(number: seeid?cube.id:cube.face(2),cube: cube,index:2),
      ),
      Transform(
        transform: Matrix4.identity()..translate(0.0, 0.0, -cubesize / 2),
        alignment: FractionalOffset.center,
        child: Side(number: seeid?cube.id:cube.face(3),cube: cube,index:3),
      ),
      Transform(
        transform: Matrix4.identity()
          ..rotateY(-pi / 2)
          ..translate(cubesize / 2, 0.0,0.0 ),
        alignment: FractionalOffset.centerRight,
        child: Side(number: seeid?cube.id:cube.face(4),cube: cube,index:4),
      ),
      Transform(
        transform: Matrix4.identity()
          ..rotateX(pi / 2)
          ..translate(0.0, cubesize / 2, 0.0),
        alignment: FractionalOffset.bottomCenter,
        child: Side(number: seeid?cube.id:cube.face(5),cube: cube,index:5),
      ),
      Transform(
        transform: Matrix4.identity()
          ..rotateY(pi)
          ..translate(0.0, 0.0, -cubesize / 2),
        alignment: FractionalOffset.center,
        child: Side(number: seeid?cube.id:cube.face(6),cube: cube,index:6),
      ),
    ];**/

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
          child: Side(number: seeid?cube.id:cube.face(numbers[k+3]+1),cube: cube,index:numbers[k+3]+1),
        ),
      );
    }

    /**faces.add(rawfaces[numbers[3]]);
    faces.add(rawfaces[numbers[4]]);
    faces.add(rawfaces[numbers[5]]);**/

    return faces.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
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
