import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FavoriteField {
  static const title = 'title';
  static const favoriteId = 'favoriteId';
  static const subscribed = 'subscribed';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

class FavoriteObject extends Equatable {
  const FavoriteObject({
    this.favoriteId,
    this.title,
    this.subscribed,
    this.createdAt,
    this.updatedAt,
  });

  factory FavoriteObject.fromDocument(Map<String, dynamic> document) {
    return FavoriteObject(
      favoriteId: document[FavoriteField.favoriteId].toString(),
      title: document[FavoriteField.title].toString(),
      subscribed: document[FavoriteField.subscribed] as bool,
      createdAt: (document[FavoriteField.createdAt] as Timestamp).toDate(),
      updatedAt: (document[FavoriteField.updatedAt] as Timestamp).toDate(),
    );
  }

  static const String clnName = 'favorites_v1';

  final String title;
  final String favoriteId;
  final bool subscribed;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object> toDocument() {
    return {
      FavoriteField.title: title,
      FavoriteField.favoriteId: favoriteId,
      FavoriteField.subscribed: subscribed,
      FavoriteField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
      FavoriteField.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  bool isEqualTo(String target) {
    return title == target;
  }

  @override
  List<Object> get props => [title, favoriteId];

  @override
  String toString() {
    return '''Favorite: {
  title: $title,
  favoriteId: $favoriteId,
  subscribed: $subscribed,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
}''';
  }
}
