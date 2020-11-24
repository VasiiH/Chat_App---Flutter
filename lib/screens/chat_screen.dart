import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();  // clear the message input
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final User user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      } else {
        print('something wrong');
      }
    } catch (e) {}
  }

  // void getMessages()async {
  //   final msg = await  _fireStore.collection('msg').get(); //Calling getDocuments() is deprecated in favor of get().
  //   for(var m in msg.docs){ //documents has been deprecated in favor of docs.
  //     print(m.data()); //Getting a snapshots' data via the data getter is now done via the data() method.
  //   }
  // }

  void messageStream() async {
    await for (var snapShot in _fireStore.collection('msg').snapshots()) {
      for (var message in snapShot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController, // clear the message input
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear(); // clear the message input
                      DateTime now = DateTime.now();
                      _fireStore.collection('msg').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': (now.hour.toString() +
                            ":" +
                            now.minute.toString() +
                            ":" +
                            now.second.toString() +
                            '/' +
                            now.day.toString() +
                            '/' +
                            now.month.toString() +
                            '/' +
                            now.year.toString()),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance.collection('msg').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else {
            final messages = snapshot.data.docs;
            List<MessageBubble> messageBubbles = [];
            for (var message in messages) {
              final messageText = message['text'];
              final messageSender = message['sender'];
              //final messageTime = message[time];

              final messageBubble = MessageBubble(
                sender: messageSender,
                // time: messageTime,
                text: messageText,
              );

              messageBubbles.add(messageBubble);
            }
            return Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                children: messageBubbles,
              ),
            );
          }
        });
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text});

  final String sender;
  //final String time;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black38,
          ),),
          Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text('$text from',
                    style: TextStyle(fontSize: 15.0),))),
        ],
      ),
    );
  }
}
