package com.plus.anji.ajflutterplugin;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AjFlutterPlugin */

public class AjFlutterPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "aj_flutter_plugin");
    channel.setMethodCallHandler(new AjFlutterPlugin(registrar));
  }

  private AjFlutterPlugin(Registrar registrar){
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    try {
      Context context = mRegistrar.context();
      if (call.method.equals("getPlatformVersion")) {
        PackageManager pm = context.getPackageManager();
        PackageInfo info = pm.getPackageInfo(context.getPackageName(), 0);
        Map<String, String> map = new HashMap<String, String>();
        map.put("appName", info.applicationInfo.loadLabel(pm).toString());
        map.put("packageName", context.getPackageName());
        map.put("version", info.versionName);
        map.put("buildNumber", String.valueOf(info.versionCode));
        result.success(map);
      } else if (call.method.equals("launchUrl")){
        String url = call.argument("url");
        if(canLaunchUrl(url)){
          Intent launchIntent;
          launchIntent = new Intent(Intent.ACTION_VIEW);
          launchIntent.setData(Uri.parse(url));
          context.startActivity(launchIntent);
          if (mRegistrar.activity() == null) {
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
          }
        }
        result.success(null);

      }else {
        result.notImplemented();
      }
    } catch (PackageManager.NameNotFoundException e){
      result.error("Not found", e.getMessage(), null);
    }
  }


  private boolean canLaunchUrl(String url){
    Intent launchIntent = new Intent(Intent.ACTION_VIEW);
    launchIntent.setData(Uri.parse(url));
    ComponentName componentName =
            launchIntent.resolveActivity(mRegistrar.context().getPackageManager());

    boolean canLaunch =
            componentName != null
                    && !"{com.android.fallback/com.android.fallback.Fallback}"
                    .equals(componentName.toShortString());
    return  canLaunch;
  }


  private void canLaunch(String url, Result result) {
    boolean canLaunch = this.canLaunchUrl(url);
    result.success(canLaunch);
  }

}
