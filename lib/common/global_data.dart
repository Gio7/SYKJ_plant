import 'package:flutter/foundation.dart';

import 'buy_shop.dart';

class GlobalData {
  static String get baseUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return kDebugMode ? 'http://192.168.0.111:19300' : 'https://api.plantidentifier.co';
    }
    //https://test.plantidentifier.co
    return 'http://192.168.0.111:19300';//'https://api.plantidentifier.co';
  }

  /// 用户协议
  static String termsOfUseUrl = 'https://plantidentifier.co/terms_of_use.html';

  /// 隐私协议
  static String privacyNoticeUrl = 'https://plantidentifier.co/privacy_policy.html';

  static String unsubscribeUrl = '';

  static BuyShop buyShop = BuyShop();

  static String versionName = '';

  /// 唯一标识
  static String adId = '';

  static String? fcmToken;

  static String telegramGroup = '';

  static String email = '';
}
