
import 'package:flutter/material.dart';
import 'package:threedslidepuzzle/widget/CubeAssembly.dart';
import 'package:threedslidepuzzle/widget/OneCube.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

import '../const.dart';

class Pseudo3dSlider extends StatefulWidget {
  @override
  _Pseudo3dSliderState createState() => _Pseudo3dSliderState();
}

class _Pseudo3dSliderState extends State<Pseudo3dSlider> {

  double x = 0;
  double y = 0;

  void onDragUpdate(Offset offset) {
    setState(() {
      x = x+offset.dx;
      //y = y+offset.dy;
    });
  }

  double get XturnRatio {
    const step = 70.0;
    var k = x / step;
    return k;
  }

  double get YturnRadio {
    const step = 70.0;
    var j = y / step;
    return j;
  }

  @override
  Widget build(BuildContext context) {
    Matrix3 XtransformMatrix=Matrix3.rotationX(pi/2*YturnRadio);
    Matrix3 YtransformMatrix=Matrix3.rotationY(pi/2*XturnRatio);
    return Column(
      children: [
        Text("${(90*XturnRatio).toStringAsFixed(3)}"),
        Expanded(
          child: GestureDetector(
            //behavior: HitTestBehavior.opaque,
            //onPanStart: (details) => onDragUpdate(details.globalPosition),
            onPanUpdate: (details) => onDragUpdate(details.delta),
            child: Container(
              color: colorless,
              child: CubeAssembly(k: XturnRatio, j: YturnRadio/*,XtransformMatrix:XtransformMatrix,YtransformMatrix:YtransformMatrix,num:0*/),
            ),
          ),
        ),
      ],
    );
  }
}