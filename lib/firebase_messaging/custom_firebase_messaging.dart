import 'package:app_innovation/firebase_messaging/custom_local_notification.dart';
import 'package:app_innovation/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class CustomFirebaseMessaging {
  final CustomLocalNotification _customLocalNotification;

  CustomFirebaseMessaging._internal(this._customLocalNotification);

  static final CustomFirebaseMessaging _singleton =
      CustomFirebaseMessaging._internal(CustomLocalNotification());

  factory CustomFirebaseMessaging() => _singleton;

  Future<void> initialize({VoidCallback? callback}) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (message.data['forceFetchRC'] != null) return callback?.call();

      if (notification != null && android != null) {
        _customLocalNotification.androidNotification(notification, android);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['goTO'] != null) {
        navigatorKey.currentState?.pushNamed(message.data['goTO']);
      }

      if (message.data['forceFetchRC'] != null) callback?.call();
    });
  }

  getTokenFirebase() async =>
      debugPrint(await FirebaseMessaging.instance.getToken());

  printDetails() async =>
      _customLocalNotification.getListMessage();
}
