import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DeviceTokenField {
  static const token = 'token';
  static const userId = 'userId';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

class DeviceToken extends Equatable {
  const DeviceToken({
    this.userId,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceToken.fromDocument(Map<String, dynamic> document) {
    return DeviceToken(
      userId: document[DeviceTokenField.userId].toString(),
      token: document[DeviceTokenField.token].toString(),
      createdAt: (document[DeviceTokenField.createdAt] as Timestamp).toDate(),
      updatedAt: (document[DeviceTokenField.updatedAt] as Timestamp).toDate(),
    );
  }

  static const String clnName = 'device_tokens_v1';

  final String token;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object> toDocument() {
    return {
      DeviceTokenField.userId: userId,
      DeviceTokenField.token: token,
      DeviceTokenField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
      DeviceTokenField.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object> get props => [userId, token];

  @override
  String toString() {
    return '''DeviceToken: {
  userId: $userId,
  token: $token,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
}''';
  }
}
