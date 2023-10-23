import 'package:flutter/material.dart';
import 'package:lightbulb/model/chatMessageModel.dart';
import 'package:lightbulb/utils/AuthService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lightbulb/utils/FirebaseHandler.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<ChatMessageModel> messages = [];
  @override
  void initState() {
    super.initState();

    retrieveAllMessage(); //Retrieve all message from the database when page initialize
    // Scroll to the bottom when the widget first builds
  }

  // Send message function
  void sendMessage(String message) {
    DatabaseReference messageRef =
        FirebaseDatabase.instance.ref().child('messages');
    String? messageId =
        messageRef.push().key; // Generate a unique ID for the message

    messageRef.child(messageId!).set({
      'text': message,
      'timestamp': DateTime.now().toUtc().toString(),
      'type': FirebaseHandler.getUID(),
    }).then((_) {
      print('Message added successfully');
      retrieveLatestMessage();
    }).catchError((error) {
      //print('Error adding message: $error');
    });
  }

  void retrieveAllMessage() async {
    DatabaseReference messageRef =
        FirebaseDatabase.instance.ref().child('messages');
    DataSnapshot snapshot = await messageRef.orderByChild('timestamp').get();
    Map<dynamic, dynamic>? messageMap =
        snapshot.value as Map<dynamic, dynamic>?;
    if (messageMap != null) {
      List<ChatMessageModel> newMessages = [];

      // Now you can use messageMap as a Map
      // ...
      messageMap.forEach((key, value) {
        newMessages.add(ChatMessageModel(
          messageContent: value['text'],
          messageType: value['type'],
          timestamp: value['timestamp'],
        ));
      });
      // Sort the messages by timestamp (newest first)
      newMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      setState(() {
        messages.clear();
        messages.addAll(newMessages);
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } else {
      //print("Snapshot value is not a Map");
    }
  }

  void retrieveLatestMessage() async {
    DatabaseReference messageRef =
        FirebaseDatabase.instance.ref().child('messages');
    Query query = messageRef.orderByChild('timestamp').limitToLast(1);
    DataSnapshot snapshot = await query.get();
    Map<dynamic, dynamic>? messageMap =
        snapshot.value as Map<dynamic, dynamic>?;
    if (messageMap != null) {
      // Now you can use messageMap as a Map
      // ...
      messageMap.forEach((key, value) {
        messages.add(ChatMessageModel(
          messageContent: value['text'],
          messageType: value['type'],
          timestamp: value['timestamp'],
        ));
      });

      setState(() {
        //Do Something here
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } else {
      //print("Snapshot value is not a Map");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      AuthService authService = AuthService();
                      await authService.signOut(context: context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    //backgroundImage: NetworkImage(chatUsers[0].imageURL),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Test",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      retrieveLatestMessage();
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 60),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType.toString() !=
                            FirebaseHandler.getUID().toString()
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType.toString() !=
                                FirebaseHandler.getUID().toString()
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        sendMessage(messageController.text);
                        messageController.text = '';
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
