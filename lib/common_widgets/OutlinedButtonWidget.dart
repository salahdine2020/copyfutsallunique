import 'package:flutter/material.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final String text;
  final Widget screen;
  final fct;
  const OutlinedButtonWidget({Key? key, required this.text, required this.screen, this.fct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        fct;
        //todo: Get.to(() => screen);
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Text(text.toUpperCase(), style: KLatoTextStyleTextButton),
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        textStyle: KLatoTextStyleText,
        side: BorderSide(width: 2.0, color: colorButton),
      ),
    );
  }
}
