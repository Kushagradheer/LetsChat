import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:letschat/Widgets/widgets.dart';
import 'package:letschat/helper/constants.dart';
import 'package:letschat/services/database.dart';
import 'package:letschat/views/conversationScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController userNameSearchTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapShot;

  Widget SearchList() {
    return searchSnapShot != null
        ? Expanded(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchSnapShot.docs.length,
                  itemBuilder: (context, index) {
                    return SearchTile(
                      userName: searchSnapShot.docs[index].get("name"),
                      userEmail: searchSnapShot.docs[index].get("email"),
                    );
                  }),
            ),
          )
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUserName(userNameSearchTextEditingController.text)
        .then((val) {
      print(val.toString());
      setState(() {
        searchSnapShot = val;
      });
      print("$searchSnapShot");
    });
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
//            color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName),
                Text(userEmail),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoomAndStartConversation(
                  username: userName,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.all(8),
                child: Text("Message"),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Creating Chat Room and Sending user to chat page
  createChatRoomAndStartConversation({String username}) {
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> charRoomMap = {
        "user": users,
        "chatroomId": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
      //  DatabaseMethods().getConversationMessages(chatRoomId);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("Dont give your own username");
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Column(
            children: [
              //Padding by me
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: userNameSearchTextEditingController,
                        decoration:
                            InputDecoration(hintText: "Search Username"),
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.search),
                      onTap: () {
                        initiateSearch();
                      },
                    ),
                  ],
                ),
              ),
              SearchList(),
            ],
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
