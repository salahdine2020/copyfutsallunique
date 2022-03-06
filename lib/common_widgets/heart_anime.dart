import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

class HeartAnime extends StatelessWidget {
  final double? size;
  HeartAnime(this.size);
  @override
  Widget build(BuildContext context) {
    return AnimateWidget(
      duration: Duration(milliseconds: 8000),
      //tween: Tween(begin: 0.5, end: 1.4),
      curve: Curves.elasticOut,
      builder: (context, animate) {
        return Transform.rotate(
          //scale: value!.toDouble(),//animate.triggerAnimation(restart: false),
          angle: 0,
          child: Center(
            child: Icon(
              Icons.favorite,
              size: size,
              color: Colors.red,
            ),
          ),
        );
      }
    );
  }
}
