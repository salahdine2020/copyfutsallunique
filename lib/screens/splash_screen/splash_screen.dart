// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:futsal_unique/common_widgets/instaDart_richText.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Developed with by:'),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0, top: 10),
                child: GestureDetector(
                  onTap: () async {
                    const url = 'https://wwww.taneflit.com';
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: true,
                        enableJavaScript: true,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    'wwww.taneflit.com',
                    style: kBillabongFamilyTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InstaDartRichText(
                  kBillabongFamilyTextStyle.copyWith(fontSize: 70)),
              SizedBox(
                height: 50,
              ),
              Image.asset(
                //todo: 'assets/images/instagram_logo.png',
                'assets/images/logotanflite.PNG',
                height: 150,
                width: 200,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
