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
      required this.XtransformMatrix,
      required this.YtransformMatrix,
      required this.cube});


  final cubeModel cube;

  static double d = cubesize / 2;

  final Matrix3 XtransformMatrix;
  final Matrix3 YtransformMatrix;
  bool seeid=false;


  List<Vector3> position = [
    Vector3(0, d, 0),
    Vector3(-d, 0, 0),
    Vector3(0, 0, d),
    Vector3(d, 0, 0),
    Vector3(0, -d, 0),
    Vector3(0, 0, -d),
  ];

  double findZpoint(int i) {
    Vector3 result =
        YtransformMatrix.transform(XtransformMatrix.transform(position[i]));
    return result.z;
  }

  List<Widget> arrangeFace() {
    List<Widget> rawfaces = [
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
    ];

    List<Widget> faces = [];
    List<int> numbers = [0];
    Map<int, double> ZpointOfindex = {};
    for (int i = 0; i < 6; i++) {
      ZpointOfindex[i] = findZpoint(i);
    }


    for (int i = 1; i < 6; i++) {
      bool added = false;
      for (int j = 0; j < numbers.length; j++) {
        if (ZpointOfindex[i]! < ZpointOfindex[numbers[j]]!) {
          numbers.insert(j, i);
          added = true;
          break;
        }
      }
      if (!added) {
        numbers.add(i);
      }
    }
    faces.add(rawfaces[numbers[0]]);
    faces.add(rawfaces[numbers[1]]);
    faces.add(rawfaces[numbers[2]]);
    faces.add(rawfaces[numbers[3]]);
    faces.add(rawfaces[numbers[4]]);
    faces.add(rawfaces[numbers[5]]);

    return faces;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: cubesize,
        width: cubesize,
        color: black,
        child: Stack(children: arrangeFace())/**GestureDetector(
          behavior:HitTestBehavior.translucent,
          onTap: () {

            Provider.of<gameProvider>(context,listen:false).move(cube);
          },
          child: Stack(children: arrangeFace()),
        )**/,
      ),
    );
  }
}
