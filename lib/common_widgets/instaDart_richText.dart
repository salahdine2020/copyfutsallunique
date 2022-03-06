import 'package:flutter/material.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class InstaDartRichText extends StatelessWidget {
  final TextStyle textStyle;
  InstaDartRichText(this.textStyle);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'fut',
        style: GoogleFonts.graduate(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: kWhiteColorBlackOpacity,
        ),
        //textStyle.copyWith(color: Theme.of(context).primaryColorDark),
        children: <TextSpan>[
          TextSpan(
            text: 'sal',
            style: GoogleFonts.graduate(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: kWhiteColorBlackOpacity,
            ),
          ),
        ],
      ),
    );
  }
}
