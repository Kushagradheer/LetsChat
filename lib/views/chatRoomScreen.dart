import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letschat/helper/authenticate.dart';
import 'package:letschat/helper/constants.dart';
import 'package:letschat/helper/helperFunction.dart';
import 'package:letschat/services/auth.dart';
import 'package:letschat/services/database.dart';
import 'package:letschat/views/conversationScreen.dart';
import 'package:letschat/views/searchScreen.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomListTile(
                        snapshot.data.docs[index].data["chatroomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data.docs[index].get("chatroomId"));
                  },
                ),
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRoomSenders(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Flutter Chat App"),
            backgroundColor: Colors.blue[800],
            centerTitle: true,
            actions: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.exit_to_app),
                ),
                onTap: () {
                  authMethods.signOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Authenticate()));
                },
              ),
            ],
          ),
          body: chatRoomList(),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.search,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          )),
    );
  }
}

class ChatRoomListTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomListTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${userName.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: TextStyle(
                fontSize: 26,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
