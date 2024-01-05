import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ParkingLotIcon extends StatelessWidget {
  const ParkingLotIcon({
    Key? key,
    this.inverted = false,
    this.size = 20.0,
    this.fontSize = 14.0,
  }) : super(key: key);

  final bool inverted;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: inverted ?  primaryButtonBlue : Colors.white,
        borderRadius: BorderRadius.circular(size/2),
        border: Border.all(
          width: 1,
          color: inverted ? Colors.white : primaryButtonBlue,
        ),
      ),
      child: Center(
        child: Text('P', style: TextStyle(
          fontSize: fontSize,
          color: inverted ? Colors.white : primaryButtonBlue,
        )),
      ),
    );
  }
}
