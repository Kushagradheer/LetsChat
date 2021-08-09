import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/Widgets/widgets.dart';
import 'package:letschat/helper/constants.dart';
import 'package:letschat/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController =
      new TextEditingController();
  Stream<QuerySnapshot> chatMessageStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.docs[index].get("message"),
                      snapshot.data.docs[index].get("sendBy") ==
                          Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      };

      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Stack(
            children: [
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Padding by me
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: messageTextEditingController,
                              decoration:
                                  InputDecoration(hintText: "Send Message.."),
                            ),
                          ),
                          GestureDetector(
                            child: Icon(Icons.send),
                            onTap: () {
                              sendMessage();
                              //initiateSearch();
                            },
                          ),
                        ],
                      ),
                    ),
                    // SearchList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isSendByMe ? 0 : 24, vertical: isSendByMe ? 0 : 8),
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(23),
                    topLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
      ),
    );
  }
}
