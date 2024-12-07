import 'package:flutter/foundation.dart';

class GlobalData {
  static String get baseUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return kDebugMode ? 'http://192.168.0.111:19300' : 'https://api.plantidentifier.co';
    } else if (packageName.contains('identification')){
      return 'http://192.168.0.111:19300';
    } else {
      return 'https://api.plantidentifier.co';
    }
  }

  /// 用户协议
  static String termsOfUseUrl = 'https://plantidentifier.co/terms_of_use.html';

  /// 隐私协议
  static String privacyNoticeUrl = 'https://plantidentifier.co/privacy_policy.html';

  static String unsubscribeUrl = '';

  static String versionName = '';

  static String packageName = '';

  /// 唯一标识
  static String adId = '';

  static String? fcmToken;

  static String telegramGroup = '';

  static String email = '';
}
