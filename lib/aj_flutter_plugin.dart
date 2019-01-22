import 'dart:async';

import 'package:flutter/services.dart';


const MethodChannel _channel = const MethodChannel('aj_flutter_plugin');

///launch application webview
Future<void> launch(String urlString){
  return _channel.invokeMethod('launchUrl', {'url': urlString});

}
class AjFlutterPlugin {

  AjFlutterPlugin({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber
  });
  static Future<AjFlutterPlugin> _fromPlatform;

  ///获取版本信息
  static Future<AjFlutterPlugin> platformVersion() async {
    if(_fromPlatform == null){
      final Completer<AjFlutterPlugin> completer = Completer<AjFlutterPlugin>();
      _channel.invokeMethod("getPlatformVersion").then((dynamic result){
        final Map<dynamic, dynamic> map = result;
        print(map.toString());
        completer.complete(AjFlutterPlugin(
            appName: map["appName"],
            packageName: map["packageName"],
            version: map["version"],
            buildNumber: map["buildNumber"]
        ));
      }, onError: completer.completeError);

      _fromPlatform = completer.future;
    }

    return _fromPlatform;
  }
  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  final String buildNumber;

}
