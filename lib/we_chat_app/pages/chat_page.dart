import 'dart:convert';
import 'dart:io';

import 'package:chat_app/we_chat_app/pages/group_info.dart';
import 'package:chat_app/we_chat_app/service/database_service.dart';
import 'package:chat_app/we_chat_app/widgets/message_tile.dart';
import 'package:chat_app/we_chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  File? selectedImage;
  bool isImageSelected = false;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: isImageSelected
                        ? SizedBox.expand(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: selectedImage != null
                            ? Image.file(
                          selectedImage!,
                          height: 300,
                        )
                            : SizedBox.shrink(),
                      ),
                    )
                        : TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle:
                        TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: isImageSelected
                        ? () {
                      sendImage();
                      setState(() {
                        isImageSelected = false;
                      });
                    }
                        : () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      isImageSelected = true;
      selectedImage = File(pickedImage!.path);
    });
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    message: ChatMessage(
                        message: snapshot.data.docs[index]['message'],
                        isImage: snapshot.data.docs[index]['isImage'],
                        sender: snapshot.data.docs[index]['sender'],
                        time: snapshot.data.docs[index]['time'].toString()),
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender']);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  sendImage() async {
    if (selectedImage != null) {
      print("send image");
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(File(selectedImage!.path));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      ChatMessage chatMessageMap = ChatMessage(
          image: downloadUrl,
          message: null,
          isImage: true,
          sender: widget.userName,
          time: DateTime.now().millisecondsSinceEpoch.toString());

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
    }

    setState(() {
      messageController.clear();
      selectedImage = null;
    });
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      print("send message");
      ChatMessage chatMessageMap = ChatMessage(
          message: messageController.text,
          isImage: false,
          sender: widget.userName,
          time: DateTime.now().millisecondsSinceEpoch.toString());

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
        selectedImage = null;
      });
    }
  }
}
