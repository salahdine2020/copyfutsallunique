import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futsal_unique/models/chat_params.dart';
import 'package:futsal_unique/models/models.dart';

class ChatUsers {
  final String? id;
  final String? recentMessage;
  final String? recentSender;
  final Timestamp? recentTimestamp;
  final List<dynamic>? memberIds;
  final List<UserModelClass>? memberInfo;
  final dynamic? readStatus;

  ChatUsers({
    this.id,
    this.recentMessage,
    this.recentSender,
    this.recentTimestamp,
    this.memberIds,
    this.memberInfo,
    this.readStatus, ChatParams? chatParams,
  });

  factory ChatUsers.fromDoc(DocumentSnapshot doc) {
    return ChatUsers(
      id: doc.id,
      recentMessage: doc['recentMessage'],
      recentSender: doc['recentSender'],
      recentTimestamp: doc['recentTimestamp'],
      memberIds: doc['memberIds'],
      readStatus: doc['readStatus'],
    );
  }
}
