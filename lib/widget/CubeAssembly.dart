import 'dart:math';
import 'package:flutter/material.dart';
import 'package:threedslidepuzzle/const.dart';
import 'package:vector_math/vector_math_64.dart';

import 'OneCube.dart';

class CubeAssembly extends StatelessWidget {
  CubeAssembly({required this.k, required this.j});

  final double k;
  final double j;

  Matrix3? XtransformMatrix;
  Matrix3? YtransformMatrix;


  @override
  Widget build(BuildContext context) {

    int temppickup=1;


    List<Vector3> translateVectors=[];


    for (int x=0;x<2;x++){
      for (int y=0;y<2;y++){
        for (int z=0;z<2;z++){
          translateVectors.add(Vector3(x*cubesize-cubesize/2,y*cubesize-cubesize/2,z*cubesize-cubesize/2));
        }
      }
    }
    print(translateVectors);
    XtransformMatrix=Matrix3.rotationX(pi/2*j);
    YtransformMatrix=Matrix3.rotationY(pi/2*k);

    double findZpoint(int i){
      Vector3 result=YtransformMatrix!.transform(XtransformMatrix!.transform(translateVectors[i].clone()));



      return result.z;
    }
    Vector3 temp0=YtransformMatrix!.transform(XtransformMatrix!.transform(translateVectors[0].clone()));



    List<Widget> arrangeCube(){
      List<Widget> cubes=[];
      List<int> numbers=[0];
      Map<int, double> ZpointOfindex={};
      for (int i=0;i<temppickup;i++){
        ZpointOfindex[i]=findZpoint(i);
      }

      for (int i=1;i<temppickup;i++){
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

      for (int i=0;i<temppickup;i++){
        cubes.add(Transform(
          transform: Matrix4.identity()..setTranslation(translateVectors[numbers[i]]),
          alignment: FractionalOffset.center,
          child: /*Point(num:numbers[i])*/OneCube(k: k,j: j,XtransformMatrix: XtransformMatrix!,YtransformMatrix: YtransformMatrix!,num:numbers[i]),
        ));
      }

      return cubes;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${YtransformMatrix?.row0.x.toStringAsFixed(2)}"
            ),
            Text(
                "${YtransformMatrix?.row0.y.toStringAsFixed(2)}"
            ),
            Text(
                "${YtransformMatrix?.row0.z.toStringAsFixed(2)}"
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${YtransformMatrix?.row1.x.toStringAsFixed(2)}"
            ),
            Text(
                "${YtransformMatrix?.row1.y.toStringAsFixed(2)}"
            ),
            Text(
                "${YtransformMatrix?.row1.z.toStringAsFixed(2)}"
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${YtransformMatrix?.row2.x.toStringAsFixed(2)}"
            ),
            Text(
                "${YtransformMatrix?.row2.y.toStringAsFixed(2)}"
            ),
            Text(
                "${YtransformMatrix?.row2.z.toStringAsFixed(2)}"
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${translateVectors[0].x.toStringAsFixed(2)}"
            ),
            Text(
                "${translateVectors[0].y.toStringAsFixed(2)}"
            ),
            Text(
                "${translateVectors[0].z.toStringAsFixed(2)}"
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${temp0.x.toStringAsFixed(2)}"
            ),
            Text(
                "${temp0.y.toStringAsFixed(2)}"
            ),
            Text(
                "${temp0.z.toStringAsFixed(2)}"
            ),
          ],
        ),


        Expanded(
          child: Transform(
            transform:Matrix4.identity()
              ..rotateY(pi/2*k)..rotateX(pi/2*j),
            alignment: FractionalOffset(0.5,0.5),
            child: Container(
              height:cubesize*2,
              width: cubesize*2,
              child: Stack(
                children: arrangeCube(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Point extends StatelessWidget {
  const Point({required this.num}) ;

  final int num;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      color: cubeColor[num],
    );
  }
}




