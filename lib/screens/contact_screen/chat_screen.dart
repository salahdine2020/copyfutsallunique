///import 'package:futsal_unique/models/chat_model.dart';
import 'package:futsal_unique/models/chat_params.dart';
import 'package:futsal_unique/screens/contact_screen/chat.dart';
///import 'package:futsal_unique/mywidgets/chat_bot/chat_bot_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final ChatParams? chatParams;

  const ChatScreen({Key? key, this.chatParams}) : super(key: key);

  Widget showName({String title = 'Sav'}) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('sav').doc(chatParams!.peerId).get(),
      builder: (context, snap) {
        var data = snap.data;
        if (!snap.hasData) return Text('Sav');
        if (snap.hasError) return Text('Sav');
        return Text(
          'username',//todo'${data["nom"]?.toString()}',
          style: TextStyle(color: Colors.black),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            'admin_chat',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Chat(chatParams: chatParams),
    );
  }
}
