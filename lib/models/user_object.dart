import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserField {
  static const name = 'name';
  static const userId = 'userId';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

class UserObject extends Equatable {
  const UserObject({
    required this.name,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  }) : assert(userId != '');

  factory UserObject.fromDocument(Map<String, dynamic> document) {
    return UserObject(
      name: document[UserField.name].toString(),
      userId: document[UserField.userId].toString(),
      createdAt: (document[UserField.createdAt] as Timestamp).toDate(),
      updatedAt: (document[UserField.updatedAt] as Timestamp).toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      UserField.name: name,
      UserField.userId: userId,
      UserField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
      UserField.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static const String clnName = 'users_v1';

  final String name;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object> get props => [name, userId];

  @override
  String toString() {
    return '''UserObject: {
  name: $name,
  userId: $userId,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
}''';
  }
}
