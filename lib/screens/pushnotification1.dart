import 'package:authendication_firebase/model/PushNotification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../notification_bedge.dart';

class PushNotification1 extends StatefulWidget {
  @override
  _PushNotification1State createState() => _PushNotification1State();
}

class _PushNotification1State extends State<PushNotification1> {
  //initiallize some value
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;

  PushNotification? _notificationinfo;

  //register notification
  void registerNotification() async {
    await Firebase.initializeApp();
    //instance for fire base messeging

    _messaging = FirebaseMessaging.instance;

    //three type of state in notification
    //not determined (null), granted (true) and decline (false)

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
      //main message

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          datatitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _totalNotificationCounter++;
          _notificationinfo = notification;
        });
        if (notification != null) {
          showSimpleNotification(Text(_notificationinfo!.title!),
              leading: NotificationBadege(
                  totalNotification: _totalNotificationCounter),
              subtitle: Text(_notificationinfo!.body!),
              background: Colors.cyan.shade700,
              duration: Duration(seconds: 2));
        }
      });
    } else {
      print("permission declines by user");
    }
  }
  checkForInitialMessage() async{
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage !=null){
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
        datatitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      setState(() {
        _totalNotificationCounter++;
        _notificationinfo = notification;
      });
    }
  }

  @override
void initState() {
    //when app is in background

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        datatitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _totalNotificationCounter++;
        _notificationinfo = notification;
      });
    });
    //normal notification
    registerNotification();
    //when appis in terminatedstate
    checkForInitialMessage();

    _totalNotificationCounter=0;
    super.initState();
  }
  //check the initial message we recived

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("push notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Fluter Push notification",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            //showing notification bedge which will
            // count the total notification that we receive
            NotificationBadege(totalNotification: _totalNotificationCounter),
            //if notification info is not null
            SizedBox(height: 30),
            _notificationinfo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Title:${_notificationinfo!.datatitle ?? _notificationinfo!.title}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      SizedBox(height: 9),
                      Text(
                        "Title:${_notificationinfo!.dataBody ?? _notificationinfo!.body}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
