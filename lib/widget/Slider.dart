import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threedslidepuzzle/model/cubemodel.dart';
import 'package:threedslidepuzzle/model/gameProvider.dart';
import 'package:threedslidepuzzle/widget/CubeAssembly.dart';


import 'dart:math';

import '../const.dart';

class Pseudo3dSlider extends StatelessWidget {
  const Pseudo3dSlider();


  void onDragUpdate(Offset offset, BuildContext context) {
    Provider.of<gameProvider>(context,listen: false).rotate(offset.dx, offset.dy);
  }

  @override
  Widget build(BuildContext context) {
    final rank = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
                create: (context) => gameProvider(rank),
                child:
                    Consumer<gameProvider>(builder: (context, provider, child) {
                  return GestureDetector(
                    onPanUpdate: (details) => onDragUpdate(details.delta,context),
                    child: Container(
                      color: Colors.black,
                      child: CubeAssembly(),
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}
