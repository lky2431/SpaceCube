
import 'package:flutter/material.dart';
import 'package:threedslidepuzzle/widget/Slider.dart';
class StartingPage extends StatelessWidget {
  const StartingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Cube Size',
              ),
              ElevatedButton(onPressed: (){goToGame(context,2);}, child: Text("2X2")),
              ElevatedButton(onPressed: (){goToGame(context,3);}, child: Text("3X3")),
              ElevatedButton(onPressed: (){goToGame(context,4);}, child: Text("4X4")),
              ElevatedButton(onPressed: (){goToGame(context,5);}, child: Text("5X5")),
            ],
          ),
        ));
  }

  goToGame(BuildContext context, int range){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Pseudo3dSlider(),
        settings: RouteSettings(
          arguments: range,
        ),
      ),
    );
  }
}
