import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:threedslidepuzzle/model/gameProvider.dart';
import 'package:threedslidepuzzle/widget/CubeAssembly.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;


import 'dart:math';

import '../const.dart';
import '../model/Star.dart';

class CubeGame extends StatelessWidget {
  const CubeGame();


  void onDragUpdate(Offset offset, BuildContext context) {
    Provider.of<gameProvider>(context,listen: false).rotate(offset.dx, offset.dy);
  }

  void onDragEnd(Velocity v,BuildContext context){
    Provider.of<gameProvider>(context,listen: false).inertia(v);
  }





  @override
  Widget build(BuildContext context) {
    final rank = ModalRoute.of(context)!.settings.arguments as int;
    Size size=MediaQuery.of(context).size;
    return Scaffold(

      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
                create: (context) => gameProvider(rank),
                child:
                    Consumer<gameProvider>(builder: (context, provider, child) {
                  return Stack(
                    children: [
                      CustomPaint(
                        size: Size(size.width, size.height),
                        painter: StarPainter(context: context),
                      ),
                      Listener(
                        onPointerSignal: (PointerSignalEvent event) {
                          if (event is PointerScrollEvent) {
                            Provider.of<gameProvider>(context,listen: false).changeCubeSize(event.scrollDelta.dy>0);
                          }
                        },
                        child: GestureDetector(
                          onPanUpdate: (details) => onDragUpdate(details.delta,context),
                          onPanEnd: (details)=>onDragEnd(details.velocity,context),

                          child: Container(
                            color: Colors.transparent,
                            child: CubeAssembly(),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
          ),
        ],
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  StarPainter({required this.context});
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.color);
    List<Star> stars=Provider.of<gameProvider>(context, listen: false).stars;
    double xdelta=Provider.of<gameProvider>(context,listen: false).xdelta;
    double ydelta=Provider.of<gameProvider>(context,listen: false).ydelta;
    for (Star star in stars){
      drawStar(star, canvas,xdelta,ydelta,size);
    }
    var rect = Offset.zero & size;

  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void drawStar(Star star, Canvas canvas,double xdelta,double ydelta,Size size) {
    var paint = Paint()
      ..color = Colors.yellowAccent.withOpacity(star.opacity)
      ..style = PaintingStyle.fill
    ..maskFilter=MaskFilter.blur(BlurStyle.normal, 4);
    double width=size.width;
    double height=size.height;
    double starx=star.x*width-width*(xdelta/4);
    if (starx<0){
      starx+=width;
    }
    if (starx>width){
      starx-=width;
    }

    double stary=star.y*height-height*(ydelta/4);
    if (stary<0){
      stary+=height;
    }
    if (stary>height){
      stary-=height;
    }


    canvas.drawCircle(Offset(starx, stary), 5, paint);
  }



}

