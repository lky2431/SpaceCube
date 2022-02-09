import 'dart:math';

class cubeModel{
  Map<int, int> faces={};
  final int id;
  int x;
  int y;
  int z;
  Map<int, bool> enlighted= {1:false,2:false,3:false,4:false,5:false,6:false};

  cubeModel(this.id,this.x,this.y,this.z);


  //create cubeModel with random number initiate
  factory cubeModel.init(int id, int x, int y, int z, int randomrange){
    cubeModel initCube=cubeModel(id, x, y, z);
    Random random = new Random();
    for (int i=1;i<=6;i++){
      initCube.setFace(i, random.nextInt(randomrange)+1);
    }
    return initCube;
  }

  void setFace(int face, int num){
    faces[face]=num;
  }

  int face(int i){
    return faces[i]!;
  }

  void moveTo(List<int> vacancy){
    x=vacancy[0];
    y=vacancy[1];
    z=vacancy[2];
  }

  void enlight(int face, bool yes){
    enlighted[face]=yes;

  }

  bool getlight(int face){
    return enlighted[face]!;
  }


  @override
  String toString() {
    return 'cubeModel{id: $id, x: $x, y: $y, z: $z}';
  }
}

class cubeAssemblyModel{


  cubeAssemblyModel();
  List<cubeModel> cubes=[];
  List<int> vacancy=[];
  int _range=0;

  Map<int, List<int>> groupingMatrix={
    1:[1,0,10],
    2:[0,-10,1],
    3:[1,-10,0],
    4:[0,-10,-1],
    5:[1,0,-10],
    6:[-1,-10,0]
  };

  Map<int, List<cubeModel>> groupingCache={};

  void initiate(int range){
    _range=range;
    int id=0;
    //add cubes into assembly
    for (int x =0;x<range;x++){
      for (int y =0;y<range;y++){
        for (int z =0;z<range;z++){
          if (x==0||y==0||z==0||x==range-1||y==range-1||z==range-1){
            cubeModel c= cubeModel.init(id, x, y, z,range*range);
            cubes.add(c);
            if(y==range-1){
              groupingCache.pushList(1,c);
            }
            if(x==0){
              groupingCache.pushList(2,c);
            }
            if(z==range-1){
              groupingCache.pushList(3,c);
            }
            if(x==range-1){
              groupingCache.pushList(4,c);
            }
            if(y==0){
              groupingCache.pushList(5,c);
            }
            if(z==0){
              groupingCache.pushList(6,c);
            }
            id++;
          }

        }
      }
    }



    //assign numbers to the cubes
    for (int i=1;i<=6;i++){
      //sorting the face with factor
      List<int> factor=groupingMatrix[i]!;
      List<cubeModel> cubesinaFace=groupingCache[i]!;
      cubesinaFace.sort((a,b)=>(a.x*factor[0]+a.y*factor[1]+a.z*factor[2]-(b.x*factor[0]+b.y*factor[1]+b.z*factor[2])));
      //assign

      for (int j=0; j<cubesinaFace.length;j++){
        cubes[cubesinaFace[j].id].setFace(i, j+1);
      }
    }

    //removing one cube from the assembly
    Random random = new Random();
    int randomnumber=random.nextInt((pow(range,3) as int)-(pow(range-2,3) as int) -2);
    cubeModel cubetoBeRemoved=cubes[randomnumber];
    vacancy=[cubetoBeRemoved.x,cubetoBeRemoved.y,cubetoBeRemoved.z];
    cubes.removeAt(randomnumber);


    //blend the cube
    for (int i=0;i<range*100;i++){
      List<cubeModel> neighbor=[];

      for (cubeModel cube in cubes){
          if (cubeIsNext(cube.x, cube.y, cube.z)){
            neighbor.add(cube);
          }
      }

      int randomcube=random.nextInt(neighbor.length-1);
      cubeModel cubetomove=neighbor[randomcube];
      int x=cubetomove.x;
      int y=cubetomove.y;
      int z=cubetomove.z;

      cubetomove.moveTo(vacancy);
      vacancy=[x,y,z];
    }

    //enlight the neighbor
    resetEnlight();



  }

  bool cubeIsNext(int x, int y, int z){
    num d= (x-vacancy[0]).abs()+(y-vacancy[1]).abs()+(z-vacancy[2]).abs();
    if (d==1){
      return true;
    }
    return false;
  }

  void setVacancy(int x, int y, int z){
    vacancy=[x,y,z];
  }

  void resetEnlight(){
    print(vacancy);
    for (cubeModel cube in cubes){
      for (int i=1;i<=6;i++){
        cube.enlight(i, false);
      }
      if (cubeIsNext(cube.x, cube.y, cube.z)){
        if(cube.x==vacancy[0] && vacancy[0]==0){
          cube.enlight(2,true);
        }
        if (cube.x==vacancy[0] && vacancy[0]==_range-1){
          cube.enlight(4,true);
        }
        if (cube.y==vacancy[1] && vacancy[1]==0){
          cube.enlight(5,true);
        }
        if (cube.y==vacancy[1] && vacancy[1]==_range-1){
          cube.enlight(1,true);
        }
        if (cube.z==vacancy[2] && vacancy[2]==0){
          cube.enlight(6,true);
        }
        if (cube.z==vacancy[2] && vacancy[2]==_range-1){
          cube.enlight(3,true);
        }

      }
    }
  }



}

extension on Map{
  pushList(int i, cubeModel c){
    if (this.containsKey(i)){
      this[i].add(c);
    }else{
      this[i]=[c];
    }
  }
}