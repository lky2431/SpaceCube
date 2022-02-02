
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import '../const.dart';
import 'Side.dart';




class OneCube extends StatelessWidget {
  OneCube({required this.k, required this.j,required this.XtransformMatrix, required this.YtransformMatrix,required this.num});

  final double k;
  final double j;

  static double d=cubesize/2;

  final Matrix3 XtransformMatrix;
  final Matrix3 YtransformMatrix;
  final int num;


  List<Vector3> position=[
    Vector3(0,d,0),
    Vector3(-d,0,0),
    Vector3(0,0,d),
    Vector3(d,0,0),
    Vector3(0,-d,0),
    Vector3(0,0,-d),
  ];

  double findZpoint(int i){
    Vector3 result=YtransformMatrix.transform(XtransformMatrix.transform(position[i]));
    return result.z;
  }


  List<Widget> arrangeFace(){
    List<Widget> rawfaces=[
      Positioned(
          left: 50,
          top: 50,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(0.0,0.0,-cubesize/2)
              ..rotateX(-pi/2),
            alignment: FractionalOffset.bottomCenter,
            child: Side(number: num),
          )),
      Positioned(
        left: 0,
        top: 100,
        child: Transform(
          transform: Matrix4.identity()
            ..translate(0.0,0.0,-cubesize/2)
            ..rotateY(pi/2),
          alignment: FractionalOffset.centerRight,
          child: Side(number: num),
        ),
      ),
      Positioned(
        left:50,
        top: 100,
        child: Transform(
          transform: Matrix4.identity()..translate(0.0,0.0,-cubesize/2),
          alignment: FractionalOffset.centerLeft,
          child: Side(number: num),
        ),
      ),
      Positioned(
        right:0,
        top: 100,
        child: Transform(
          transform: Matrix4.identity()..translate(0.0,0.0,-cubesize/2)..rotateY(-pi/2),
          alignment: FractionalOffset.centerLeft,
          child: Side(number: num),
        ),
      ),
      Positioned(
        left:50,
        top: 150,
        child: Transform(
          transform: Matrix4.identity()..translate(0.0,0.0,-cubesize/2)
            ..rotateX(pi / 2),
          alignment: FractionalOffset.topCenter,
          child: Side(number: num),
        ),
      ),
      Positioned(
        left:50,
        top: 200,
        child: Transform(
          transform: Matrix4.identity()..translate(0.0,0.0,-cubesize/2)
            ..rotateX(-pi)..translate(0.0,cubesize,-cubesize),
          alignment: FractionalOffset.topCenter,
          child: Side(number: num),
        ),
      ),
    ];

    List<Widget> faces=[];
    List<int> numbers=[0];
    Map<int, double> ZpointOfindex={};
    for (int i=0;i<6;i++){
      ZpointOfindex[i]=findZpoint(i);
    };


    for (int i=1;i<6;i++){
      bool added=false;
      for (int j=0;j<numbers.length;j++){
        if (ZpointOfindex[i]! < ZpointOfindex[numbers[j]]!){
          numbers.insert(j, i);
          added=true;
          break;
        }
      }
      if(!added){
        numbers.add(i);
      }
    }
    faces.add(rawfaces[numbers[3]]);
    faces.add(rawfaces[numbers[4]]);
    faces.add(rawfaces[numbers[5]]);

    return faces;
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        height: 50*5,
        width: 50*3,
        child: GestureDetector(
          onTap:(){
            print("on cube pressed");
          },
          child: Stack(
              children: arrangeFace()
          ),
        ),
      ),
    );
  }
}



