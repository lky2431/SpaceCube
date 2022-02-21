import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';

import 'package:flutter/material.dart';

import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:vector_math/vector_math.dart';

import 'Star.dart';
import 'package:flutter/foundation.dart' show kIsWeb;




class gameProvider extends ChangeNotifier{
  // the sensitivity to rotate the puzzle
  static int sensitivity=100;
  static double inertiaSensitivity=30000;
  late final int _range;

  late cubeAssemblyModel cubeassembly;
  double xdelta=0.42;
  double ydelta=0.42;
  List<Star> _stars=[];
  late Timer inertiaTimer=Timer(Duration.zero, (){});
  double cubesize=100;



  gameProvider(int range){
    cubeassembly=cubeAssemblyModel()..initiate(range);
    for (int i =0; i<50;i++){
      double opacity=Random().nextDouble()*0.8+0.1;
      double x=Random().nextDouble();
      double y=Random().nextDouble();
      bool direction=Random().nextDouble()>0.5?true:false;
      _stars.add(Star(x,y,opacity,direction));
    }

    _range=range;
    Timer.periodic(
      const Duration(milliseconds: 30),
          (timer) {
        for (Star star in _stars){
          star.flash();
          notifyListeners();
        }
      },
    );

    if (!kIsWeb){
      switch (range){
        case 3:
          cubesize=80;
          break;
        case 4:
          cubesize=50;
          break;
        case 5:
          cubesize=40;
          break;

      }
    }
  }

  List<Star> get stars=>_stars;

  //the cubes inside the puzzle
  List<cubeModel> get cubes=> cubeassembly.cubes;

  //rotate the puzzle
  void rotate(double x, double y){
    xdelta=xdelta+x/sensitivity;
    ydelta=ydelta+y/sensitivity;
    if (xdelta>4||xdelta<-4){
      xdelta=0;
    }
    if (ydelta>4||ydelta<-4){
      ydelta=0;
    }
    notifyListeners();
  }

  void changeCubeSize(bool increase){
    if (increase){
      if (cubesize<250){
        cubesize+=5;
      }
    }else{
      if (cubesize>50){
        cubesize-=5;
      }
    }
    notifyListeners();
  }

  //the range of the puzzle
  int get range=>_range;

  List<double> get vacancy=>cubeassembly.vacancy;


  void inertia(Velocity velocity){
    print(velocity);
    if (inertiaTimer!=null){
      inertiaTimer.cancel();
    }
    inertiaTimer=Timer.periodic(
      const Duration(milliseconds: 100),
          (timer) {
        xdelta+=(velocity.pixelsPerSecond.dx)/inertiaSensitivity;
        ydelta+=velocity.pixelsPerSecond.dy/inertiaSensitivity;
        if (xdelta>4||xdelta<-4){
          xdelta=0;
        }
        if (ydelta>4||ydelta<-4){
          ydelta=0;
        }

        notifyListeners();
      },
    );
  }


  void move(cubeModel cube){
    double x=cube.x;
    double y=cube.y;
    double z=cube.z;

    if (cubeassembly.cubeIsNext(x, y, z)){
      double rawx=cube.x;
      double rawy=cube.y;
      double rawz=cube.z;
      List<double> rawvacancy=vacancy;
      for (int i=0;i<52;i++){
        // disable all the block
        cubeassembly.setVacancy(-1,-1,-1);
        cubeassembly.resetEnlight();
        //perform animation
        Future.delayed(Duration(milliseconds: 10*i),(){
          if (i!=51){
            double ratio=Curves.bounceInOut.transform(0.02*i);
            cube.moveTo([
              (rawvacancy[0]-rawx)*ratio+rawx,
              (rawvacancy[1]-rawy)*ratio+rawy,
              (rawvacancy[2]-rawz)*ratio+rawz
            ]);

          }else{
            cubeassembly.setVacancy(x,y,z);
            cubeassembly.resetEnlight();
          }
          notifyListeners();
        });
      }
    }
  }

  bool checkwin(){
    for (cubeModel cube in cubes){
      double x=cube.x;
      double y=cube.y;
      double z=cube.z;
      if (y==range-1 && cube.face(1)!=(x+1)+z*range){
        return false;
      }
      if (x==0 && cube.face(2)!=(range-1-y)*range+(z+1)){
        return false;
      }
      if (z==range-1 && cube.face(3)!=(x+1)+range*(range-1-y)){
        return false;
      }
      if (x==range-1 && cube.face(4)!=(range-1-y)*range+(range-z)){
        return false;
      }
      if (y==0 && cube.face(5)!=(x+1)+(range-1-z)*range){
        return false;
      }
      if (z==0 && cube.face(6)!=(range-x)+(range-1-y)*range){
        return false;
      }
    }
    return true;
  }

}

