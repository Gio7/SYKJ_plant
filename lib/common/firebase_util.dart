import 'package:firebase_analytics/firebase_analytics.dart';

class FireBaseUtil {
  static late FirebaseAnalytics _analytics;

  static late FirebaseAnalyticsObserver observer;

  static void initServices() {
    _analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // Firebase Analytics
  static FirebaseAnalytics getFirebaseAnalytics() {
    return _analytics;
  }

  static void logCurrentScreen(String screenName) {
    _analytics.logScreenView(screenName: screenName);
  }

  /// 通用事件记录
  /// 
  /// [eventName] 事件名称 [EventName]类型
  // delete_draft
  // rename_draft
  // import_draft
  // preview_draft
  // simple_inspiration_import
  static void logEvent(String eventName, {Map<String, Object>? parameters}) {
    _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  ///请求创作内容
  ///
  /// [tag] 歌曲风格
  /// [instrumental] 启用Enable,  关闭Disable
  /// [engineType]  suno3.0，suno3.5,udio32
  /// [createMode]  simple简单模式 expert专业模式
  /// [createType]  normal普通生成 extend扩歌  getWholeSong合成歌曲
  static void logEventRequestCreation({
    required String tag,
    required String instrumental,
    required String createMode,
    required String createType,
  }) {
    _analytics.logEvent(
      name: EventName.requestCreation,
      parameters: {
        'tag': tag,
        'instrumental': instrumental,
        'createMode': createMode,
        'createType': createType,
      },
    );
  }

  ///下载音乐
  ///
  /// [pageName] 页面名称,[PageName]类型
  static void logEventSaveCreation(String pageName) {
    _analytics.logEvent(
      name: EventName.saveCreation,
      parameters: {"pageName": pageName},
    );
  }

  ///删除音乐
  ///
  /// [workStatus] 制作状态（看删除的是成功的还是失败的），实际状态为主，字符串形式上报
  static void logEventDeleteCreation(String workStatus) {
    _analytics.logEvent(
      name: EventName.deleteCreation,
      parameters: {"workStatus": workStatus},
    );
  }

  ///播放音乐
  ///
  /// [pageName] 页面名称,[PageName]类型
  /// [musicType] 音乐类型 生成结果：creation ，  模板音乐： template
  static void logEventPlayMusic(String pageName, String musicType) {
    _analytics.logEvent(
      name: EventName.playMusic,
      parameters: {"pageName": pageName, "musicType": musicType},
    );
  }

  ///分享音乐
  ///
  /// [pageName] 页面名称,[PageName]类型
  static void logEventShareRequest(String pageName) {
    _analytics.logEvent(
      name: EventName.shareRequest,
      parameters: {"pageName": pageName},
    );
  }

  /// 创建订单
  ///
  /// [productId] 商品id
  static void logEventCreateOrder(String productId) {
    _analytics.logEvent(
      name: EventName.createOrder,
      parameters: {"productId": productId},
    );
  }

  /// 支付订单
  ///
  /// [productId] 商品id
  /// [result] 支付结果
  static void logEventPayOrder(String productId, String result) {
    _analytics.logEvent(
      name: EventName.payOrder,
      parameters: {"productId": productId, "result": result},
    );
  }

  /// 消耗订单（验证订单）
  ///
  /// [productId] 商品id
  /// [result] 验证结果
  static void logEventConsumptionOrder(String productId, String result) {
    _analytics.logEvent(
      name: EventName.consumptionOrder,
      parameters: {"productId": productId, "result": result},
    );
  }

  ///故障事件
  ///
  /// [pageName] 页面名称,[PageName]类型
  /// [errorMessage] 错误信息
  static void logEventErrorEvent(String pageName, String errorMessage) {
    _analytics.logEvent(
      name: EventName.errorEvent,
      parameters: {"pageName": pageName, "errorMessage": errorMessage},
    );
  }

  ///保存草稿
  ///
  /// [saveDraftType] "newDraft 新建草稿 overwriteDraft 覆盖草稿"
  static void logEventSaveDraft(String saveDraftType) {
    _analytics.logEvent(
      name: EventName.saveDraft,
      parameters: {"saveDraftType": saveDraftType},
    );
  }

  /// 页面浏览
  static void logEventPageView(String pageName) {
    _analytics.logEvent(
      name: EventName.pageView,
      parameters: {'pageName': pageName},
    );
  }

  /// 按钮点击
  static void logEventButtonClick({
    required String buttonName,
    String? pageName,
    String? popupName,
    String? result,
  }) {
    _analytics.logEvent(
      name: EventName.buttonClick,
      parameters: {
        'buttonName': buttonName,
        if (pageName != null) 'pageName': pageName,
        if (popupName != null) 'popupName': popupName,
        if (result != null) 'result': result,
      },
    );
  }

  /// 弹窗展示
  static void logEventPopupView(String popupName) {
    _analytics.logEvent(
      name: EventName.popupView,
      parameters: {'popupName': popupName},
    );
  }
}

/// 事件名称
class EventName {
  /// 页面浏览
  static const String pageView = 'page_view';

  /// 按钮点击
  static const String buttonClick = 'button_click';

  /// 弹窗展示
  static const String popupView = 'popup_view';

  /// 同意隐私协议
  static const String privacyAgree = 'privacy_agree';

  /// 拒绝隐私协议
  static const String privacyDecline = 'privacy_decline';

  /// 请求创作内容
  static const String requestCreation = 'request_creation';

  /// 创作结果
  static const String resultCreation = 'result_creation';

  /// 保存创作结果
  static const String saveCreation = 'save_creation';

  /// 删除创作结果
  static const String deleteCreation = 'delete_creation';

  /// 播放音乐
  static const String playMusic = 'play_music';

  /// 拉起分享
  static const String shareRequest = 'share_request';

  /// 创建订单
  static const String createOrder = 'create_order';

  /// 支付订单
  static const String payOrder = 'pay_order';

  /// 消耗订单
  static const String consumptionOrder = 'consumption_order';

  /// 故障事件
  static const String errorEvent = 'error_event';

  /// 保存草稿
  static const String saveDraft = 'save_draft';

  /// 删除草稿
  static const String deleteDraft = 'delete_draft';

  /// 草稿重命名
  static const String renameDraft = 'rename_draft';

  /// 导入草稿
  static const String importDraft = 'import_draft';

  /// 预览草稿
  static const String previewDraft = 'preview_draft';

  /// 简单模式导入灵感
  static const String simpleInspirationImport = 'simple_inspiration_import';
}

/// 参数 - 页面名称
class PageName {
  /// 主页
  static const String homePage = 'home_page';

  /// 创作页
  static const String createPage = 'create_page';

  /// 创作历史
  static const String creationsPage = 'creations_page';

  /// 设置页面
  static const String settingsPage = 'settings_page';

  /// 设置二级页面
  static const String moreSettingsPage = 'more_settings_page';

  /// 点数使用记录
  static const String pointsHistoryPage = 'points_history_page';

  /// 点数购买页面
  static const String pointsPurchasePage = 'points_purchase_page';

  /// 会员购买页面
  static const String proPurchasePage = 'pro_purchase_page';

  /// 注册页
  static const String signUpPage = 'sign_up_page';

  /// 注册验证页面
  static const String registrationVerificationPage = 'registration_verification_page';

  /// 邮箱登录页
  static const String mailLoginPage = 'mail_login_page';

  /// 重置密码页
  static const String resetPasswordPage = 'reset_password_page';

  /// 重置密码验证页面
  static const String resetVerificationPage = 'reset_verification_page';

  /// 简单模式页面
  static const String simpleModePage = 'simple_mode_page';

  /// 专家模式页面
  static const String expertModePage = 'expert_mode_page';

  /// 歌词放大页面
  static const String lyricsZoomPage = 'lyrics_zoom_page';

  /// 草稿页面
  static const String draftPage = 'draft_page';
}

/// 参数 - 按钮名称
class ButtonName {
  /// 全局会员入口
  static const String proButton = 'pro_button';

  /// 全局点数购买入口
  static const String pointsButton = 'points_button';

  /// 登出
  static const String logoutButton = 'logout_button';

  /// 注销
  static const String deleteAccount = 'delete_account';

  /// 设置按钮
  static const String settingsButton = 'settings_button';

  /// 展开播放器
  static const String expandPlayer = 'expand_player';

  /// 收起播放器
  static const String collapsePlayer = 'collapse_player';

  /// 随机风格
  static const String randomMusic = 'random_music';

  /// 清空风格
  static const String clearStyle = 'clear_style';

  /// 清空歌词
  static const String clearLyrics = 'clear_lyrics';

  /// 清空标题
  static const String clearTitle = 'clear_title';

  /// 去生成按钮（历史页，点数记录页）
  static const String goCreateButton = 'go_create_button';

  /// 复制用户id
  static const String copyAccountID = 'copy_accountID';

  /// 退订
  static const String unsubscribeButton = 'unsubscribe_button';

  /// 点数历史History
  static const String pointsHistory = 'points_history';

  /// restore
  static const String restoreButton = 'restore_button';

  /// 导入草稿按钮
  static const String importDraftButton = 'import_draft_button';

  /// 重命名草稿按钮
  static const String remaneDraftButton = 'remane_draft_button';

  /// 删除草稿按钮
  static const String deleteDraftButton = 'delete_draft_button';

  /// 弹窗导入草稿
  static const String popupImportDraftButton = 'popup_import_draft_button';

  /// 弹窗删除草稿
  static const String popupDeleteDraftButton = 'popup_delete_draft_button';

  /// 歌词放大按钮
  static const String lyricsZoomButton = 'lyrics_zoom_button';

  /// 歌词缩小按钮
  static const String lyricsNarrowButton = 'lyrics_narrow_button';

  /// 简单模式随机灵感按钮
  static const String simpleSwitchInspiration = 'simple_switch_inspiration';

  /// 清除扩歌按钮
  static const String extendClearButton = 'extend_clear_button';

  /// part与fullsong标识
  static const String songLogo = 'song_logo';

  /// 扩歌按钮
  static const String extendButton = 'extend_button';

  /// 复用按钮
  static const String reuseButton = 'reuse_button';
}
