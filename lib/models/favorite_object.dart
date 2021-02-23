import 'package:ag_viewer/models/program_object.dart';
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
    this.program,
    this.createdAt,
    this.updatedAt,
  });

  factory FavoriteObject.fromDocument(Map<String, dynamic> document) {
    return FavoriteObject(
      favoriteId: document[FavoriteField.favoriteId].toString(),
      title: document[FavoriteField.title].toString(),
      subscribed: document[FavoriteField.subscribed] as bool,
      program: ProgramObject.fromDocument(document),
      createdAt: (document[FavoriteField.createdAt] as Timestamp).toDate(),
      updatedAt: (document[FavoriteField.updatedAt] as Timestamp).toDate(),
    );
  }

  static const String clnName = 'favorites_v1';

  final String title;
  final String favoriteId;
  final bool subscribed;
  final ProgramObject program;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object> toDocument(ProgramObject program) {
    return {
      FavoriteField.title: title,
      FavoriteField.favoriteId: favoriteId,
      FavoriteField.subscribed: subscribed,
      FavoriteField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
      FavoriteField.updatedAt: FieldValue.serverTimestamp(),
      // ProgramObjectも詰める
      ProgramField.pfm: program.pfm,
      ProgramField.duration: program.duration,
      ProgramField.isBroadcast: program.isBroadcast,
      ProgramField.isRepeat: program.isRepeat,
      ProgramField.from: program.from,
      ProgramField.to: program.to,
    };
  }

  bool isEqualTo(ProgramObject target) {
    return title == target.title &&
        program.from == target.from &&
        program.to == target.to;
  }

  @override
  List<Object> get props => [title, favoriteId, program.from, program.to];

  @override
  String toString() {
    return '''Favorite: {
  title: $title,
  favoriteId: $favoriteId,
  subscribed: $subscribed,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
  program: $program,
}''';
  }
}
