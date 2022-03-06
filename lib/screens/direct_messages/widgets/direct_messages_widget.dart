import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/screens/direct_messages/nested_screens/chat_screen.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/screens/search_screen/search_screen.dart';
import 'package:futsal_unique/services/api/database_service.dart';
import 'package:futsal_unique/services/services.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:futsal_unique/common_widgets/user_badges.dart';
import 'package:provider/provider.dart';

class DirectMessagesWidget extends StatefulWidget {
  final SearchFrom searchFrom;
  final File? imageFile;
  DirectMessagesWidget({required this.searchFrom, required this.imageFile});
  @override
  _DirectMessagesWidgetState createState() => _DirectMessagesWidgetState();
}

class _DirectMessagesWidgetState extends State<DirectMessagesWidget> {
  Stream<List<ChatUsers>>? chatsStream;
  UserModelClass? _currentUser;

  @override
  void initState() {
    super.initState();
    final UserModelClass? currentUser = Provider.of<UserData>(context, listen: false).currentUser;
    setState(() => _currentUser = currentUser);
    AuthService.updateTokenWithUser(currentUser);
  }

  Stream<List<ChatUsers>> getChats() async* {
    List<ChatUsers> dataToReturn = [];

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('chats')
        .where('memberIds', arrayContains: _currentUser!.id!)
        .orderBy('recentTimestamp', descending: true)
        .snapshots();

    await for (QuerySnapshot q in stream) {
      for (var doc in q.docs) {
        ChatUsers chatFromDoc = ChatUsers.fromDoc(doc);
        var memberIds = chatFromDoc.memberIds;
        int receiverIndex = 0;

        // Getting receiver index
        memberIds!.forEach((userId) {
          if (userId != _currentUser!.id!) {
            receiverIndex = memberIds.indexOf(userId);
          }
        });

        List<UserModelClass> membersInfo = [];

        UserModelClass receiverUser = await DatabaseService.getUserWithId(memberIds[receiverIndex]);
        membersInfo.add(_currentUser!);
        membersInfo.add(receiverUser);

        ChatUsers chatWithUserInfo = ChatUsers(
          id: chatFromDoc.id,
          memberIds: chatFromDoc.memberIds,
          memberInfo: membersInfo,
          readStatus: chatFromDoc.readStatus,
          recentMessage: chatFromDoc.recentMessage,
          recentSender: chatFromDoc.recentSender,
          recentTimestamp: chatFromDoc.recentTimestamp,
        );

        dataToReturn.removeWhere((chat) => chat.id == chatWithUserInfo.id);

        dataToReturn.add(chatWithUserInfo);
      }
      yield dataToReturn;
    }
  }

  _buildChat(ChatUsers chat, String currentUserId) {
    final bool isRead = chat.readStatus[currentUserId];
    final TextStyle readStyle = TextStyle(fontWeight: isRead ? FontWeight.w400 : FontWeight.bold);
    List<UserModelClass> users = chat.memberInfo!;
    int receiverIndex = users.indexWhere((user) => user.id != _currentUser!.id!);
    int senderIndex = users.indexWhere((user) => user.id == chat.recentSender);

    if (widget.searchFrom == SearchFrom.createStoryScreen) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(users[receiverIndex].profileImageUrl!),
          // users[receiverIndex].profileImageUrl.isEmpty
          //     ? AssetImage(placeHolderImageRef)
          //     : CachedNetworkImageProvider(users[receiverIndex].profileImageUrl),
        ),
        title: Row(
          children: [
            Text(
              users[receiverIndex].name!,
            ),
            UserBadges(user: users[receiverIndex], size: 15),
          ],
        ),
        trailing: FlatButton(
          child: Text(
            'Send',
            style: kFontSize18TextStyle.copyWith(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  receiverUser: users[receiverIndex],
                  imageFile: widget.imageFile,
                ),
              ),
            ),
          },
        ),
        // onTap: () =>
      );
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 28.0,
        backgroundImage: CachedNetworkImageProvider(users[receiverIndex]!.profileImageUrl!),
        // users[receiverIndex].profileImageUrl.isEmpty
        //     ? AssetImage(placeHolderImageRef)
        //     : CachedNetworkImageProvider(users[receiverIndex].profileImageUrl),
      ),
      title: Row(
        children: [
          Text(
            users[receiverIndex]!.name!,
          ),
          UserBadges(user: users[receiverIndex], size: 15),
        ],
      ),
      subtitle: Container(
        height: 35,
        child: chat.recentSender!.isEmpty!
            ? Text(
                'Chat Created',
                overflow: TextOverflow.ellipsis,
                style: readStyle,
              )
            : chat.recentMessage != null
                ? Text(
                    '${chat.memberInfo![senderIndex].name} : ${chat.recentMessage}',
                    overflow: TextOverflow.ellipsis,
                    style: readStyle,
                  )
                : Text(
                    '${chat.memberInfo![senderIndex].name} : \nSent an attachment',
                    overflow: TextOverflow.ellipsis,
                    style: readStyle,
                  ),
      ),
      trailing: Text(
        timeFormat.format(
          chat.recentTimestamp!.toDate(),
        ),
        style: readStyle,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            receiverUser: users[receiverIndex],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getChats(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SearchScreen(
                            searchFrom: widget.searchFrom,
                            imageFile: widget.imageFile,
                          ),
                  ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 5),
                      Text('Search'),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: Text(
                    'Messages',
                    style: kFontSize18TextStyle,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  ChatUsers chat = snapshot.data[index];
                  return _buildChat(chat, _currentUser!.id!);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(thickness: 1.0);
                },
                itemCount: snapshot.data.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
