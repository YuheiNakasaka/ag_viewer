import 'package:ag_viewer/blocs/bloc.dart';
import 'package:ag_viewer/models/user_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBloc extends Bloc {
  static User get fireUser => FirebaseAuth.instance.currentUser!;

  Future<void> initUser() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    final ref = FirebaseFirestore.instance
        .collection('${UserObject.clnName}')
        .doc('${UserBloc.fireUser.uid}');
    final userDoc = await ref.get();
    if (!userDoc.exists) {
      final user = UserObject(name: 'ゲスト', userId: userCredential.user!.uid)
          .toDocument();
      await ref.set(user, SetOptions(merge: true));
    }
  }

  @override
  void dispose() {}
}

final userProvider = Provider((ref) => UserBloc());
