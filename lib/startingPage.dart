
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:threedslidepuzzle/widget/Slider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'const.dart';
class StartingPage extends StatelessWidget {
  const StartingPage();

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: AutoSizeText(
                    'Space Cube',
                    style: GoogleFonts.permanentMarker().copyWith(fontSize: 84,color: oncolor),
                    maxLines: 1,

                  ),
                ),
                SizedBox(height: height*0.1,),

                Center(
                  child: AutoSizeText(
                    'Select Cube Size',
                    style: GoogleFonts.permanentMarker().copyWith(fontSize: 48,color: oncolor),
                    maxLines: 1,

                  ),
                ),
                SizedBox(height: height*0.02,),
                CubeSelector()
              ],
            ),
          ),
        ));
  }


}

class CubeSelector extends StatelessWidget {
  const CubeSelector({Key? key}) : super(key: key);

  goToGame(BuildContext context, int range){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CubeGame(),
        settings: RouteSettings(
          arguments: range,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CubeButton(number: 2, onpressed:(){goToGame(context,2);}),
        SizedBox(width: 20,),
        CubeButton(number: 3, onpressed:(){goToGame(context,3);}),
        SizedBox(width: 20,),
        CubeButton(number: 4, onpressed:(){goToGame(context,4);}),
        SizedBox(width: 20,),
        CubeButton(number: 5, onpressed:(){goToGame(context,5);}),
      ],
    );
  }
}

class CubeButton extends StatelessWidget {
  CubeButton({required this.number,required this.onpressed});
  final int number;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        print("pressed");
        onpressed();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff000033)
        ),
        width: (!kIsWeb)?width/7:120,
        height: (!kIsWeb)?width/7:120,
        child: Center(
          child: Text("$number", style: TextStyle(color: oncolor,fontSize: (!kIsWeb)?18:42),),
        ),
      ),
    );
  }
}
