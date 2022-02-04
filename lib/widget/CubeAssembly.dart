import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threedslidepuzzle/const.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:threedslidepuzzle/model/gameProvider.dart';
import 'package:vector_math/vector_math_64.dart';

import 'OneCube.dart';

class CubeAssembly extends StatelessWidget {
  CubeAssembly();

  @override
  Widget build(BuildContext context) {
    gameProvider provider = Provider.of<gameProvider>(context, listen: false);

    double xdelta = provider.xdelta;
    double ydelta = provider.ydelta;
    int range = provider.range;
    num cubenum = pow(range, 3) - pow(range - 2, 3)-1 ;

    //list to store the translation vector
    List<Vector3> translateVectors = [];
    for (cubeModel cube in provider.cubes) {
      translateVectors.add(Vector3(
          (cube.x - (range - 1) / 2) * cubesize,
          (cube.y - (range - 1) / 2) * cubesize,
          (cube.z - (range - 1) / 2) * cubesize));
    }

    // calculate the z coordinate of each cube
    Matrix3 XtransformMatrix = Matrix3.rotationX(pi / 2 * ydelta);
    Matrix3 YtransformMatrix = Matrix3.rotationY(pi / 2 * xdelta);
    double findZpoint(int i) {
      Vector3 result = YtransformMatrix.transform(
          XtransformMatrix.transform(translateVectors[i].clone()));
      return result.z;
    }

    List<int> numbers = [0];

    // arrangeing the cube according to the z index

    List<Widget> cubes = [];

    Map<int, double> ZpointOfindex = {};
    for (int i = 0; i < cubenum; i++) {
      ZpointOfindex[i] = findZpoint(i);
    }

    for (int i = 1; i < cubenum; i++) {
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

    for (int i = 0; i < cubenum; i++) {
      cubes.add(Transform(
        transform: Matrix4.identity()
          ..translate(translateVectors[numbers[i]].x,
              -translateVectors[numbers[i]].y, -translateVectors[numbers[i]].z),
        alignment: FractionalOffset.center,
        child: OneCube(
            XtransformMatrix: XtransformMatrix,
            YtransformMatrix: YtransformMatrix,
            cube: provider.cubes[numbers[i]]),
      ));
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTapDown: (detail) {
              print(numbers);
              double positionX = detail.localPosition.dx - width / 2;
              double positionY = detail.localPosition.dy - height / 2;
              List<int> hitcube=[];
              for (int num in numbers) {
                //if (num==0){
                  printd("====================================");

                  List<Vector3> cubecorner = [];
                  Vector3 v = translateVectors[num]; //vector point to center
                  for (int i in [-1, 1]) {
                    for (int j in [-1, 1]) {
                      for (int k in [-1, 1]) {
                        cubecorner.add(v.clone()
                          ..setValues(v.x + i * cubesize / 2,
                              -v.y + j * cubesize / 2, v.z + k * cubesize / 2));
                      }
                    }
                  }
                  printd("oricube in beginging ${cubecorner}");
                  Matrix3 XtransformMatrix2 = Matrix3.rotationX(-pi / 2 * ydelta);
                  for (Vector3 v in cubecorner) {
                    YtransformMatrix.transform(XtransformMatrix2.transform(v));
                  }
                  printd("cube in beginging ${cubecorner}");

                  //calculate the center of mass of a cube projection
                  double totalx = 0;
                  double totaly = 0;
                  for (Vector3 v in cubecorner) {
                    totalx += v.x;
                    totaly += v.y;
                  }
                  double meanx = totalx / 8;
                  double meany = totaly / 8;
                  printd("center at ( ${meanx}, ${meany})");

                  //deduplicate the same point and reduce the size to Vector2
                  List<Vector3> tempcubecorner = [];

                  for (Vector3 v in cubecorner) {
                    bool existed = false;
                    for (Vector3 tv in tempcubecorner) {
                      if (v.x.toInt() == tv.x.toInt() && v.y.toInt() == tv.y.toInt()) {
                        existed = true;
                      }
                    }
                    if (!existed) {
                      tempcubecorner.add(v);
                    }
                  }
                  cubecorner.clear();
                  cubecorner = tempcubecorner;
                  printd("cube after deduplicate ${cubecorner}");

                  //find the two point need to be throw away
                  cubecorner.sort((a, b) {
                    double d = (pow(b.x - meanx, 2) + pow(b.y - meany, 2)) -
                        (pow(a.x - meanx, 2) + pow(a.y - meany, 2)) as double;
                    return d.toInt();
                  });
                  printd("cube after sort ${cubecorner}");

                  /**List<double> distancematrix = [];
                      for (int i = 0; i < cubecorner.length; i++) {
                      distancematrix.add((pow(cubecorner[i].x - meanx, 2) +
                      pow(cubecorner[i].y - meany, 2)) as double);
                      }
                      printd("distance are ${distancematrix}");**/

                  if (xdelta == 0 || ydelta == 0) {
                    while (cubecorner.length > 4) {
                      cubecorner.removeLast();
                    }
                  } else {
                    while (cubecorner.length > 6) {
                      cubecorner.removeLast();
                    }
                  }

                  printd("cube after throw away ${cubecorner}");


                  //recalculate the center
                  totalx = 0;
                  totaly = 0;
                  for (Vector3 v in cubecorner) {
                    totalx += v.x;
                    totaly += v.y;
                  }
                  meanx = totalx / cubecorner.length;
                  meany = totaly / cubecorner.length;
                  printd("center at ( ${meanx}, ${meany})");



                  //find the order of the points
                  cubecorner.sort((a, b) {
                    double adegree = (a.x-meanx) >= 0
                        ? atan((a.y - meany) / (a.x - meanx))
                        : atan((a.y - meany) / (a.x - meanx)) + pi;
                    double bdegree = (b.x-meanx) >= 0
                        ? atan((b.y - meany) / (b.x - meanx))
                        : atan((b.y - meany) / (b.x - meanx)) + pi;
                    return ((adegree - bdegree)*10000).toInt();
                  });

                  printd("cube after arrange the angle ${cubecorner}");

                  //find the area of triangle with the center of mass
                  double cgtriarea = 0;
                  //find the area of triangle with the tap position
                  double touchtriarea = 0;
                  for (int i = 0; i < cubecorner.length; i++) {
                    Vector3 corner1 = cubecorner[i];
                    Vector3? corner2;
                    if (i == cubecorner.length - 1) {
                      corner2 = cubecorner[0];
                    } else {
                      corner2 = cubecorner[i + 1];
                    }
                    Vector3 vector1 = Vector3(corner1.x, corner2.x, meanx);
                    Vector3 vector2 = Vector3(corner1.y, corner2.y, meany);

                    Matrix3 CGtrianglematrix =
                    Matrix3.columns(vector1, vector2, Vector3.all(1.0));
                    cgtriarea += (CGtrianglematrix.determinant() / 100).abs();

                    vector1 = Vector3(corner1.x, corner2.x, positionX);
                    vector2 = Vector3(corner1.y, corner2.y, positionY);

                    CGtrianglematrix =
                        Matrix3.columns(vector1, vector2, Vector3.all(1.0));
                    touchtriarea += (CGtrianglematrix.determinant() / 100).abs();

                    printd(
                        "cg tri area ${cgtriarea} and touch tri area ${touchtriarea}");
                  }

                  //
                  if (touchtriarea <= cgtriarea+0.5) {
                    hitcube.add(num);
                    //print("hit");
                  }
                //}
              }
              print(hitcube);
              //find the index of touched cube
              /**int? indexOfCube;
              for (int i in hitcube){
                int newindex=numbers.indexof(i)!;
                if ((indexOfCube??0)<newindex){
                  indexOfCube=newindex;
                }
              }
              print(indexOfCube);
              if (indexOfCube!=null){
                Provider.of<gameProvider>(context,listen:false).move(provider.cubes[numbers[indexOfCube]]);
              }**/
              if (hitcube.isNotEmpty){
                Provider.of<gameProvider>(context,listen:false).move(provider.cubes[hitcube[hitcube.length-1]]);
              }



            },
            child: Builder(
              builder: (context) {
                return Container(
                  color: colorless,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..rotateY(pi / 2 * xdelta)
                      ..rotateX(pi / 2 * ydelta),
                    alignment: FractionalOffset(0.5, 0.5),
                    child: Center(
                      child: Container(
                        height: cubesize * 2,
                        width: cubesize * 2,
                        child: Stack(
                          children: cubes,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

extension on List{
  int? indexof(int i){
    for (int j=0;j<=this.length;j++){
      if (this[j]==i){
        return j;
      }
    }
  }
}
