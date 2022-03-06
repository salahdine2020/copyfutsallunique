import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final String? title;
  const LandingPage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landing Page"),
      ),
      body: Center(
        child: Text(title ?? "Null"),
      ),
    );
  }
}
