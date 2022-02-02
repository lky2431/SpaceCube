
import 'package:flutter/material.dart';
import 'package:threedslidepuzzle/widget/CubeAssembly.dart';
import 'package:threedslidepuzzle/widget/OneCube.dart';
import 'package:threedslidepuzzle/widget/Slider.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Cube Effect',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
          body: Container(
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Flutter 3D Cube Effect'),
              Expanded(
                child: Pseudo3dSlider(),
              ),
            ],
          ),
        ),
      )),
    );
  }
}







