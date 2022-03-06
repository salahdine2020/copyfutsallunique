import 'package:flutter/material.dart';
import 'package:futsal_unique/screens/direct_messages/widgets/direct_messages_widget.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/utilities/constants.dart';

class DirectMessagesScreen extends StatefulWidget {
  final Function backToHomeScreen;
  DirectMessagesScreen(this.backToHomeScreen);
  @override
  _DirectMessagesScreenState createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => widget!.backToHomeScreen!,
        ),
        title: Text('Direct'),
      ),
      body: DirectMessagesWidget(
        searchFrom: SearchFrom.messagesScreen, imageFile: null,
      ),
    );
  }
}
