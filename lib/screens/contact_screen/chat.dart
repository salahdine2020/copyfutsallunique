import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futsal_unique/models/chat_params.dart';
import 'package:futsal_unique/models/message.dart';
import 'package:futsal_unique/screens/contact_screen/message_database.dart';
import 'package:futsal_unique/screens/contact_screen/message_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Chat extends StatefulWidget {
  Chat({Key? key, this.chatParams}) : super(key: key);
  final ChatParams? chatParams;

  @override
  _ChatState createState() => _ChatState(chatParams!);
}

class _ChatState extends State<Chat> {
  final MessageDatabaseService messageService = MessageDatabaseService();
  _ChatState(this.chatParams);
  final ChatParams chatParams;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  int _nbElement = 20;
  static const int PAGINATION_INCREMENT = 20;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();

    super.dispose();
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _nbElement += PAGINATION_INCREMENT;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [buildListMessage(), buildInput()],
        ),
        isLoading ? Loading() : Container()
      ],
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder<List<Message>>(
        stream:
            messageService.getMessage(chatParams.getChatGroupId(), _nbElement),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasData) {
            List<Message> listMessage = snapshot.data ?? List.from([]);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => MessageItem(
                  message: listMessage[index],
                  userId: chatParams.userUid,
                  isLastMessage: isLastMessage(index, listMessage),
              ),
              itemCount: listMessage.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Center(child: Loading());
          }
        },
      ),
    );
  }

  bool isLastMessage(int index, List<Message> listMessage) {
    if (index == 0) return true;
    if (listMessage[index].idFrom != listMessage[index - 1].idFrom) return true;
    return false;
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: [
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages_user_admin') //todo: messages
                // todo: change by doc exact
                //todo: admin_id-4fZqMRUdXNYh8wDUauQG7podAxx2
                    .doc(chatParams
                    .getChatGroupId()
                    .toString()) //todo: chatParams.getChatGroupId().toString()
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  print(
                      'groupeID is : ${chatParams.getChatGroupId().toString()}');
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  }
                  print("before accessing userDocument");
                  var userDocument = snapshot.data;
                  print("before accessing userDocument");

                  // todo:  || userDocument['isWrite']
                  //print('pleas print userDocument here : ${userDocument.data()}');
                  return TextField(
                    onSubmitted: (value) {
                      onSendMessage(textEditingController.text, 0);
                    },
                    style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: userDocument!['isWrite'] == true
                          ? "une utilisateur est entrain d'ecrire......"
                          : 'message',
                      //hintText: 'message',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  );
                  return Container();
                  //Text(userDocument["name"]);
                }),
            // TextField(
            //   onSubmitted: (value) {
            //     onSendMessage(textEditingController.text, 0);
            //   },
            //   style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
            //   controller: textEditingController,
            //   decoration: InputDecoration.collapsed(
            //     // hintText: userDocument['isWrite'] == true
            //     //     ? "une utilisateur est entrain d'ecrire......"
            //     //     : 'message',
            //     hintText: 'message...',
            //     hintStyle: TextStyle(color: Colors.grey),
            //   ),
            // ),
          ),
          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(pickedFile);
    }
  }

  Future uploadFile(PickedFile file) async {
    String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + ".jpeg";
    try {
      Reference reference =
          FirebaseStorage.instance.ref().child("/image_chat").child(fileName);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': file.path});
      TaskSnapshot snapshot;
      if (kIsWeb) {
        snapshot = await reference.putData(await file.readAsBytes(), metadata);
      } else {
        snapshot = await reference.putFile(File(file.path), metadata);
      }

      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error! Try again!");
    }
  }

  void onSendMessage(String content, int type) async {
    if (content.trim() != '') {
      MessageDatabaseService.addMessage(
          context,
          chatParams.userUid,
          //chatParams.peer.uid,
          chatParams.peerId,
          chatParams.getChatGroupId(),
          type == 0 ? content : 'Envoyer une photo');
      messageService.onSendMessage(
        chatParams.getChatGroupId(),
        Message(
          idFrom: chatParams.userUid,
          //idTo: chatParams.peer.uid,
          idTo: chatParams.peerId,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          type: type,
        ),
      );
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      textEditingController.clear();
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitRipple(
          color: Colors.blue,
          size: 40.0,
        ),
      ),
    );
  }
}

class SpinKitRipple extends StatefulWidget {
  const SpinKitRipple({
    Key? key,
    this.color,
    this.size = 50.0,
    this.borderWidth = 6.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1800),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double? size;
  final double? borderWidth;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration? duration;
  final AnimationController? controller;

  @override
  _SpinKitRippleState createState() => _SpinKitRippleState();
}

class _SpinKitRippleState extends State<SpinKitRipple>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation1;
  Animation<double>? _animation2;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(0.0, 0.75, curve: Curves.linear),
      ),
    );
    _animation2 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller!,
        curve: const Interval(0.25, 1.0, curve: Curves.linear)));
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 1.0 - _animation1!.value!,
            child: Transform.scale(
                scale: _animation1!.value!, child: _itemBuilder(0)),
          ),
          Opacity(
            opacity: 1.0 - _animation2!.value!,
            child: Transform.scale(
                scale: _animation2!.value!, child: _itemBuilder(1)),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return SizedBox.fromSize(
      size: Size.square(widget!.size!),
      child: widget.itemBuilder != null
          ? widget.itemBuilder!(context, index)
          : DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: widget!.color!, width: widget!.borderWidth!),
              ),
            ),
    );
  }
}
