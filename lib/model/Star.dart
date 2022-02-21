import 'dart:math';

class Star{
  double x;
  double y;
  double opacity;
  bool direction;


  Star(this.x,this.y,this.opacity,this.direction);

  void flash(){
    if (direction){
      opacity+=0.01;
      if(opacity>0.95){
        direction=!direction;
      }
    }else{
      opacity-=0.01;
      if (opacity<0.05){
        direction=!direction;
      }
    }
  }

  

}