import 'package:flutter/material.dart';
import 'package:futsal_unique/utilities/themes.dart';

class IconStyle extends StatelessWidget {
  final IconData icon;

  const IconStyle(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Color(0xFF3cdc96),size: iconWidth,);
  }
}
