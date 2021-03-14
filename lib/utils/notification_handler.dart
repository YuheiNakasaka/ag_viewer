import 'dart:io';

import 'package:ag_viewer/blocs/user_bloc.dart';
import 'package:ag_viewer/models/device_token_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

late FirebaseMessaging firebaseMessaging;
late NotificationMessageObject lastNotification;

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
  required Function onLaunchCallback,
  required Function onActiveCallback,
}) async {
  firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(
    sound: true,
    badge: true,
    alert: true,
    provisional: false,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('onMessage: ${message.data}');
    final obj = NotificationMessageObject.fromJson(message.data);
    onActiveCallback(obj.path, obj.count);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
    print('onBackgroundMessage: ${message.data}');
    if (Platform.isAndroid) {
      await myBackgroundMessageHandler(message);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('onMessageOpenedApp: ${message.data}');
    final obj = NotificationMessageObject.fromJson(message.data);
    onLaunchCallback(obj.path);
  });

  final token = await firebaseMessaging.getToken();
  print('uid: ${UserBloc.fireUser.uid} token: $token');
  if (token != null && token != '') {
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
      final deviceToken = DeviceTokenObject.fromDocument(snapshot.data()!);
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

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {}
