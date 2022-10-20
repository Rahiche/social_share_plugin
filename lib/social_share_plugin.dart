import 'dart:async';
import 'package:flutter/services.dart';

typedef Future<void> OnCancelHandler();
typedef Future<void> OnErrorHandler(String error);
typedef Future<void> OnSuccessHandler(String postId);

class SocialSharePlugin {
  static const MethodChannel _channel =
      const MethodChannel('social_share_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> shareToTwitterLink({
    String? text,
    required String url,
    OnSuccessHandler? onSuccess,
    OnCancelHandler? onCancel,
  }) async {
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onSuccess":
          return onSuccess != null ? onSuccess(call.arguments) : Future.value();
        case "onCancel":
          return onCancel != null ? onCancel() : Future.value();
        //  case "onError":
        //    return onError(call.arguments);
        default:
          throw UnsupportedError("Unknown method called");
      }
    });
    return _channel.invokeMethod('shareToTwitterLink', <String, dynamic>{
      'text': text,
      'url': url,
    });
  }
}
