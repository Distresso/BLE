import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:distressoble/Model/push_message.dart';
import 'package:distressoble/store/firebase_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final FirebaseMessaging firebaseMessaging;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MessagesCubit({@required this.firebaseMessaging, @required this.flutterLocalNotificationsPlugin}) : super(InitialMessagesState());

  _saveMessage(Map<String, dynamic> message) async {
    String body;
    if (message['notification'] != null && message['notification']['body'] != null) {
      body = message['notification']['body'];
    } else if (message['aps'] != null && message['aps']['alert'] != null) {
      body = message['aps']['alert']['body'];
    } else if (message['body'] != null) {
      body = message['body'];
    } else if (message['data'] != null && message['data']['body'] != null) {
      body = message['data']['body'];
    }

    if (body != null && body != '') {
      PushMessage pushMessage = PushMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'NO TITLE SET BY BACKEND',
        message: body,
        date: DateTime.now().toString(),
        read: 'N',
        delete: 'N',
      );

      messageReceivedEvent(message: pushMessage);
    }
  }

  startFirebaseMessaging({AuthProviderUserDetails user}) async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        await _saveMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        await _saveMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        await _saveMessage(message);
      },
    );

    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
      firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered on iOS: $settings");
      });
    }

    firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print("Push Messaging token: $token");
      AppUserProfileRepository().updateProfile(user.id, {"fcmToken": token});
    });

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true, onDidReceiveLocalNotification: showNotification);
    var initializationSettings = InitializationSettings();
    var result = await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print(result);
  }

  messageReceivedEvent({PushMessage message}) async {
    emit(NewMessageState());
  }

  Future showNotification(int id, String title, String body, String payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('1', 'Distresso', 'Distresso', ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: payload);
  }
}
