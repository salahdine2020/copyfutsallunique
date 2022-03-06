import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/services/api/database_service.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:provider/provider.dart';

class ChatService {
  static Future<ChatUsers> createChat(List<UserModelClass> users, List<String> userIds) async {
    Map<String?, dynamic> readStatus = {};

    for (UserModelClass user in users) {
      readStatus[user.id] = false;
      print("Map of users is Keys : ${readStatus.keys} && values : ${readStatus.values}");
    }

    Timestamp timestamp = Timestamp.now();

    DocumentReference res = await chatsRef.add({
      'recentMessage': 'Chat Created',
      'recentSender': '',
      'recentTimestamp': timestamp,
      'memberIds': userIds,
      'readStatus': readStatus,
    });

    return ChatUsers(
      id: res.id,
      recentMessage: 'Chat Created',
      recentSender: '',
      recentTimestamp: timestamp,
      memberIds: userIds,
      readStatus: readStatus,
      memberInfo: users,
    );
  }

  static void sendChatMessage(ChatUsers chat, Message message, UserModelClass receiverUser) {
    chatsRef.doc(chat.id).collection('messages').add({
      'senderId': message.senderId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'timestamp': message.timestamp,
      'isLiked': message.isLiked ?? false,
      'giphyUrl': message.giphyUrl,
    });

    // Post post = Post(
    //   authorId: receiverUser.id,
    // );
    Post post = Post(
      authorId: 'receiverUser.id',
      commentsAllowed: true,
      id : 'a',
      imageUrl: '',
      caption : 'comment',
      likeCount : 32,
      location: 'France',
      //timestamp: ,
    );

    DatabaseService.addActivityItem(
      comment: message.text ?? '',
      currentUserId: message.senderId ?? '',
      isCommentEvent: false,
      isFollowEvent: false,
      isLikeEvent: false,
      isMessageEvent: true,
      post: post,
      recieverToken: receiverUser.token!,
    );
  }

  static void setChatRead(BuildContext context, ChatUsers chat, bool read) async {
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    chatsRef.doc(chat.id).update({
      'readStatus.$currentUserId': read,
    });
  }

  static Future<bool> checkIfChatExist(List<String> users) async {
    print(users);
    QuerySnapshot snapshot = await chatsRef
        .where('memberIds', arrayContainsAny: users)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  static Future<ChatUsers> getChatById(String chatId) async {
    DocumentSnapshot chatDocSnapshot = await chatsRef.doc(chatId).get();
    if (chatDocSnapshot.exists) {
      return ChatUsers.fromDoc(chatDocSnapshot);
    }
    return ChatUsers();
  }

  static Future<ChatUsers?> getChatByUsers(List<String> users) async {
    QuerySnapshot snapshot = await chatsRef.where('memberIds', whereIn: [
      [users[1], users[0]]
    ]).get();

    if (snapshot.docs.isEmpty) {
      snapshot = await chatsRef.where('memberIds', whereIn: [
        [users[0], users[1]]
      ]).get();
    }

    if (snapshot.docs.isNotEmpty) {
      return ChatUsers.fromDoc(snapshot.docs[0]);
    }
    return null;
  }

  static Null likeUnlikeMessage(Message message, String chatId, bool isLiked, UserModelClass receiverUser, String currentUserId) {
    chatsRef
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .update({'isLiked': isLiked});

    Post post = Post(
      authorId: 'receiverUser.id',
      commentsAllowed: true,
      id : 'a',
      imageUrl: '',
      caption : 'comment',
      likeCount : 32,
      location: 'France',
    //timestamp: ,
    );

    if (isLiked == true) {
      DatabaseService.addActivityItem(
        comment: message.text!,
        currentUserId: currentUserId,
        isCommentEvent: false,
        isFollowEvent: false,
        isLikeEvent: false,
        isMessageEvent: false,
        isLikeMessageEvent: true,
        post: post,
        recieverToken: receiverUser.token!,
      );
    } else {
      DatabaseService.deleteActivityItem(
        comment: message.text!,
        currentUserId: currentUserId,
        isFollowEvent: false,
        post: post,
        isCommentEvent: false,
        isLikeEvent: false,
        isLikeMessageEvent: true,
        isMessageEvent: false,
      );
    }
    return null;
  }
}
