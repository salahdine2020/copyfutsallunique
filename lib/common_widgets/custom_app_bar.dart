import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class CustomAppBar extends StatelessWidget {
  //final Widget ecran;
  const CustomAppBar();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(LineIcons.times, size: 30, color: Colors.black));
  }
}
