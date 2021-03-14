import 'package:ag_viewer/models/favorite_object.dart';
import 'package:ag_viewer/models/user_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgFirestore {
  AgFirestore() : db = FirebaseFirestore.instance;

  final FirebaseFirestore db;

  Future<List<FavoriteObject>> fetchFavorites() async {
    final favoritesRef = await FirebaseFirestore.instance
        .collection(UserObject.clnName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FavoriteObject.clnName)
        .get();
    return favoritesRef.docs
        .map((e) => FavoriteObject.fromDocument(e.data()!))
        .toList();
  }

  Future<DocumentReference> fetchFavorite() async {
    return db
        .collection(UserObject.clnName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FavoriteObject.clnName)
        .doc();
  }

  Future<void> deleteFavorite(FavoriteObject favorite) async {
    return db
        .collection(UserObject.clnName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FavoriteObject.clnName)
        .doc(favorite.favoriteId)
        .delete();
  }
}
