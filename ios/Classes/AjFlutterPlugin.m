#import "AjFlutterPlugin.h"

@implementation AjFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"aj_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  AjFlutterPlugin* instance = [[AjFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    
    
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result(@{
               @"appName" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
               ?: [NSNull null],
               @"packageName" : [[NSBundle mainBundle] bundleIdentifier] ?: [NSNull null],
               @"version" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
               ?: [NSNull null],
               @"buildNumber" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
               ?: [NSNull null],
               });
  } else if ([@"launchUrl" isEqualToString:call.method]) {
      NSDictionary *arguments = [call arguments];
      NSString *utlString = arguments[@"url"];
      [self launchURL:utlString result:result];
    
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)launchURL:(NSString *)urlString result:(FlutterResult)result {
    NSURL *url = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
    result(@"");
}

@end
