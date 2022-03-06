import 'package:flutter/material.dart';
import 'package:futsal_unique/utilities/themes.dart';

class CircularIconButton extends StatelessWidget {
  final Function onTap;
  final Widget icon;
  final double containerRadius;
  final EdgeInsets padding;
  final Color backColor;
  final Color splashColor;

  const CircularIconButton(
      {
      required this.icon,
      required this.onTap,
      this.containerRadius = 36,
      this.backColor = Colors.black26,
      required this.splashColor,
      this.padding = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: ()=> onTap,
        child: ClipOval(
          child: Material(
            color: backColor, // button color
            child: InkWell(
              splashColor: backColor == kBlueColorWithOpacity
                  ? backColor
                  : splashColor, // inkwell color
              child: SizedBox(
                  width: containerRadius, height: containerRadius, child: icon),
              onTap: () => onTap,
            ),
          ),
        ),
      ),
    );
  }
}
