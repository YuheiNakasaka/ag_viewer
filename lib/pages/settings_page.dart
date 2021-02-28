import 'dart:io';

import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/utils/navigator_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(
          () => version = '${packageInfo.version}(${packageInfo.buildNumber})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bkColor,
      appBar: AppBar(
        backgroundColor: Constants.baseColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Constants.mainColor,
          ),
          padding: const EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          _listItem('アプリについて', callback: () {
            pushVertical(
              context,
              const SettingsAboutPage(),
            );
          }),
          _listItem('通知の許可', callback: () {
            AppSettings.openNotificationSettings();
          }),
          _listItem('問い合わせ', callback: () async {
            var osInfo = '';
            final deviceInfo = DeviceInfoPlugin();
            if (Platform.isIOS) {
              final info = await deviceInfo.iosInfo;
              osInfo = '${info.utsname.machine}';
            } else {
              final info = await deviceInfo.androidInfo;
              osInfo = '${info.model}';
            }
            final _emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'yuhei.nakasaka@gmail.com',
              queryParameters: <String, String>{
                'subject': '${Constants.appName}のお問い合わせ',
                'body': '問い合わせ内容:\n\nお使いのデバイス:$osInfo,$version'
              },
            );
            await launch(_emailLaunchUri.toString());
          }),
          _listItem('ライセンス', callback: () {
            pushVertical(
              context,
              SettingsLicensePage(
                applicationName: Constants.appName,
                applicationVersion: '$version',
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _listItem(String title, {VoidCallback callback}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Constants.activeColor,
          fontSize: 16,
        ),
      ),
      enabled: callback != null,
      onTap: callback,
    );
  }
}

class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.baseColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Constants.mainColor,
          ),
          padding: const EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const SafeArea(
        child: InAppWebView(
          initialUrl: 'https://razokulover.com/ag_viewer/about/',
        ),
      ),
    );
  }
}

class SettingsLicensePage extends StatefulWidget {
  const SettingsLicensePage({
    this.applicationName,
    this.applicationVersion,
  });

  final String applicationName;
  final String applicationVersion;

  @override
  _SettingsLicensePageState createState() => _SettingsLicensePageState();
}

class _SettingsLicensePageState extends State<SettingsLicensePage> {
  List<List<String>> licenses = [];

  @override
  void initState() {
    super.initState();
    LicenseRegistry.licenses.listen((license) {
      final packages = license.packages.toList();
      final paragraphs = license.paragraphs.toList();
      final packageName = packages.map((e) => e).join('');
      final paragraphText = paragraphs.map((e) => e.text).join('\n');
      licenses.add([packageName, paragraphText]);
      setState(() {
        licenses = licenses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.baseColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Constants.mainColor,
          ),
          padding: const EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView.builder(
          itemCount: licenses.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Column(
                  children: [
                    Text(
                      '${widget.applicationName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('${widget.applicationVersion}'),
                    const SizedBox(height: 10),
                    const Text('powered by Flutter'),
                  ],
                ),
              );
            }
            final license = licenses[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${license[0]}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${license[1]}',
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
