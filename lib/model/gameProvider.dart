import 'package:flutter/material.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:vector_math/vector_math.dart';




class gameProvider extends ChangeNotifier{
  // the sensitivity to rotate the puzzle
  static int sensitivity=100;
  late final int _range;

  late cubeAssemblyModel cubeassembly;
  double xdelta=0;
  double ydelta=0;


  gameProvider(int range){
    cubeassembly=cubeAssemblyModel()..initiate(range);
    _range=range;
  }

  //the cubes inside the puzzle
  List<cubeModel> get cubes=> cubeassembly.cubes;

  //rotate the puzzle
  void rotate(double x, double y){
    xdelta=xdelta+x/sensitivity;
    ydelta=ydelta+y/sensitivity;
    notifyListeners();
  }

  //the range of the puzzle
  int get range=>_range;

  List<int> get vacancy=>cubeassembly.vacancy;




  void move(cubeModel cube){
    int x=cube.x;
    int y=cube.y;
    int z=cube.z;
    print("cube id ${cube.id}");

    if (cubeassembly.cubeIsNext(x, y, z)){
      cube.moveTo(vacancy);
      cubeassembly.setVacancy(x,y,z);
      cubeassembly.resetEnlight();
      notifyListeners();
    }
  }
}

