import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:futsal_unique/models/message.dart';

class MessageDatabaseService {
  final String collectionmessage = 'messages_user_admin';
  final String subcollectionmessge = 'message_user_admin';
  List<Message> _messageListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _messageFromSnapshot(doc);
    }).toList();
  }

  Message _messageFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("message not found");
    return Message.fromMap(data);
  }

  Stream<List<Message>> getMessage(String groupChatId, int limit) {
    return FirebaseFirestore.instance
        .collection(collectionmessage)
        .doc(groupChatId)
        // .collection(groupChatId)
        .collection(subcollectionmessge)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  void onSendMessage(String groupChatId, Message message) {
    var documentReference =
        FirebaseFirestore.instance.collection(collectionmessage).doc(groupChatId).collection(subcollectionmessge).doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, message.toHashMap());
    });
    FirebaseFirestore.instance.collection(collectionmessage).doc(groupChatId).update({'isWrite': false});
  }

  static Future<void> addmessage(userData, String groupChatId) async {
    final String collectionmessage = 'messages_user_admin';
    FirebaseFirestore.instance.collection(collectionmessage).doc(groupChatId).set(userData).catchError((e) {
      print(e);
    });
  }

  static Future<void> addMessage(BuildContext context, String userId, String peerId, String groupChatId, String content) async {
    final String collectionmessage = 'messages_user_admin';
    try {
      Map<String, dynamic> userInfo = {
        'IdFrom': userId,
        'IdTo': peerId,
        'date': Timestamp.now(),
        'content': content,
      };
      addmessage(userInfo, groupChatId).then((result) {});

      //Navigator.pop(context);
    } on PlatformException catch (err) {
      throw (err);
    }
  }
}
