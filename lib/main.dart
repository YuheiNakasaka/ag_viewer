import 'package:ag_viewer/app.dart';
import 'package:ag_viewer/utils/my_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
      child: App(isValidVersion: await MyConfig.isValidVersion())));
}
