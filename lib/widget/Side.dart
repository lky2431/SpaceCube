import 'package:flutter/material.dart';

import '../const.dart';

class Side extends StatelessWidget {
  const Side({required this.number});

  final int number;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: cubeColor[number],
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}