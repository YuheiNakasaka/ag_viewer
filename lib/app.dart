import 'dart:io';

import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/pages/root_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class App extends StatefulWidget {
  const App({this.isValidVersion});

  final bool isValidVersion;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return widget.isValidVersion
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: RootPage(),
            navigatorObservers: <NavigatorObserver>[
              FirebaseAnalyticsObserver(analytics: analytics)
            ],
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
          )
        : const MaterialApp(home: VersionUpDialog());
  }
}

/// A widget to show Dialog for navigating to AppStore or PlayStore
/// if the existing app version is older than required version.
class VersionUpDialog extends StatefulWidget {
  const VersionUpDialog();

  @override
  _VersionUpDialogState createState() => _VersionUpDialogState();
}

class _VersionUpDialogState extends State<VersionUpDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              content: const Text('新しいバージョンのアプリに更新する必要があります'),
              actions: <Widget>[
                // TODO(nakasaka): ストアURLが確定したら追加する
                FlatButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      _launchURL(Constants.playStoreURL);
                    } else {
                      _launchURL(Constants.appleStoreURL);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('ストアへ'),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('新しいバージョンのアプリに更新してください'),
    ));
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
