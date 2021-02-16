import 'dart:io';

import 'package:ag_viewer/blocs/user_bloc.dart';
import 'package:ag_viewer/models/device_token_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging firebaseMessaging;
NotificationMessageObject lastNotification;

class NotificationMessageObject extends Equatable {
  NotificationMessageObject.fromJson(Map<String, dynamic> json)
      : status = Platform.isIOS
            ? json['status'].toString()
            : json['data']['status'].toString(),
        path = Platform.isIOS
            ? json['path'].toString()
            : json['data']['path'].toString(),
        count = Platform.isIOS
            ? int.parse(json['count'].toString())
            : int.parse(json['data']['count'].toString()),
        clickAction = Platform.isIOS
            ? json['click_action'].toString()
            : json['data']['click_action'].toString(),
        body = Platform.isIOS
            ? json['aps']['alert']['body'].toString()
            : json['notification']['body'].toString();

  final String status;
  final String path;
  final String clickAction;
  final String body;
  final int count;

  @override
  List<Object> get props => [status, path, clickAction, body];

  @override
  String toString() {
    return '''
  status: $status
  path: $path
  clickAction: $clickAction
  body: $body
  count: $count
''';
  }
}

Future<void> initNotification({
  Function onLaunchCallback,
  Function onActiveCallback,
}) async {
  firebaseMessaging = FirebaseMessaging()
    ..requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: false,
      ),
    )
    ..onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print('settings: $settings');
    })
    ..configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final obj = NotificationMessageObject.fromJson(message);
        onActiveCallback(obj.path, obj.count);
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onLaunch: (Map<String, dynamic> message) async {
        final obj = NotificationMessageObject.fromJson(message);
        print('lastNotification: $lastNotification eventType: onLaunch');
        // iOSでは通知受信時に新規の起動でアプリが立ち上がる場合onLaunchとonResumeの二つのイベントが発火してしまう
        if (Platform.isIOS && obj == lastNotification) {
          return;
        }
        lastNotification = obj;
        onLaunchCallback(obj.path);
      },
      onResume: (Map<String, dynamic> message) async {
        final obj = NotificationMessageObject.fromJson(message);
        print('lastNotification: $lastNotification eventType: onResume');
        // iOSでは通知受信時に新規の起動でアプリが立ち上がる場合onLaunchとonResumeの二つのイベントが発火してしまう
        if (Platform.isIOS && obj == lastNotification) {
          return;
        }
        lastNotification = obj;
        onLaunchCallback();
      },
    );
  final token = await firebaseMessaging.getToken();
  print('uid: ${UserBloc.fireUser.uid} token: $token');
  if (token != '') {
    final snapshot = await FirebaseFirestore.instance
        .collection(DeviceTokenObject.clnName)
        .doc(UserBloc.fireUser.uid)
        .get();
    if (!snapshot.exists) {
      await FirebaseFirestore.instance
          .collection(DeviceTokenObject.clnName)
          .doc(UserBloc.fireUser.uid)
          .set(DeviceTokenObject(
            userId: UserBloc.fireUser.uid,
            token: token,
          ).toDocument());
    } else {
      final deviceToken = DeviceTokenObject.fromDocument(snapshot.data());
      final existToken = deviceToken.token;
      if (existToken != token) {
        await FirebaseFirestore.instance
            .collection(DeviceTokenObject.clnName)
            .doc(UserBloc.fireUser.uid)
            .update(DeviceTokenObject(
              userId: UserBloc.fireUser.uid,
              token: token,
              createdAt: deviceToken.createdAt,
            ).toDocument());
      }
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> message) async {}
