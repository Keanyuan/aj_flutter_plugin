import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:aj_flutter_plugin/aj_flutter_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    AjFlutterPlugin info;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      info = await AjFlutterPlugin.platformVersion();
      AjFlutterPlugin.clearCatch();
      platformVersion = "appName:${info.appName}\n"
          + "packageName: ${info.packageName}\n"
          + "version:${info.version}\n"
          + "buildNumber:${info.buildNumber}";

      print(platformVersion);

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            Text('$_platformVersion\n'),
            FlatButton(onPressed: () async{
              if(Platform.isAndroid){
                await launch("https://www.pgyer.com/Ti9R");
              } else if(Platform.isIOS){
                await launch("http://itunes.apple.com/cn/app/id1441492772");
              }
            }, child: Text("点击"))
          ],)
        ),
      ),
    );
  }
}
