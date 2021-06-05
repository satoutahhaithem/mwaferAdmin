
import 'package:admin_shop_app/api/messaging.dart';
import 'package:admin_shop_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:vibration/vibration.dart';



class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic('all');


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          Vibration.vibrate(duration: 500);

          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          Vibration.vibrate(duration: 500);
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Vibration.vibrate(duration: 500);

      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        elevation: 10,
        title: Text("Notification Admin",style: TextStyle(color: Colors.black),),
        centerTitle: true,

      ),
      body: ListView(


        children: [
          SizedBox(height: 80,),


          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
            child: TextFormField(
              style: TextStyle(color: Colors.black),

              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: "Enter the title",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              controller: titleController,
              validator: (val) {
                if (val.isEmpty ) {
                  return "description  must have data";
                }
              },
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
            child: TextFormField(
              style: TextStyle(color: Colors.black),

              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: "Enter the description",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              controller: bodyController,
              validator: (val) {
                if (val.isEmpty ) {
                  return "description  must have data";
                }
              },
            ),
          ),
          SizedBox(height: 10,),
          Card(
            elevation: 10,
            child: FlatButton(
              onPressed: sendNotification,
              child: Text('Send notification'),
            ),
          ),

        ]..addAll(messages.map(buildMessage).toList().reversed),
      ),
    );
  }

  Widget buildMessage(Message message) =>   Padding(
    padding: const EdgeInsets.only(right:32.0,left: 32,top: 16),
    child: Card(
        color: Colors.indigo,
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text('Title: ${message.title}',style: TextStyle(color: Colors.white),),
          subtitle: Text('Body: ${message.body}',style: TextStyle(color: Colors.white),),
        )


    ),
  );

  Future sendNotification() async {
    final response = await Messaging.sendTo(
      title: titleController.text,
      body: bodyController.text,
      // fcmToken: fcmToken,
    );


  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}
