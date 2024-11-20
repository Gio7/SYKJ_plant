import 'package:firebase_analytics/firebase_analytics.dart';

class FireBaseUtil {
  static FirebaseAnalytics? _analytics;

  static FirebaseAnalyticsObserver? observer;

  static void initAnalyticsServices() {
    _analytics = FirebaseAnalytics.instance;
    if (_analytics != null) {
      observer = FirebaseAnalyticsObserver(analytics: _analytics!);
    }
  }

  // Firebase Analytics
  // static FirebaseAnalytics getFirebaseAnalytics() {
  //   return _analytics;
  // }

  static void logCurrentScreen(String screenName) {
    _analytics?.logScreenView(screenName: screenName);
  }

  /// 通用事件记录
  ///
  /// [eventName] 事件名称 [String]类型
  static void logEvent(String eventName, {Map<String, Object>? parameters}) {
    _analytics?.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  /// 展示订阅页面
  static void membershipPageEvent(String fromPage) {
    _analytics?.logEvent(
      name: EventName.membershipPage,
      parameters: {'page_from': fromPage},
    );
  }

  /// 调起登录页面
  static void loginPageEvent(String fromPage) {
    _analytics?.logEvent(
      name: EventName.loginPage,
      parameters: {'from_event': fromPage},
    );
  }

  /// 创建订阅 weekly，year
  static void subscribeCreate(String? id) {
    _analytics?.logEvent(
      name: EventName.subscribeSelect,
      parameters: {'member_type': subscribeType(id)},
    );
  }

  /// 订阅成功 weekly，year
  static void subscribeSuccess(String? id) {
    _analytics?.logEvent(
      name: EventName.subscribeSuccess,
      parameters: {'member_type': subscribeType(id)},
    );
  }

  /// 点击疾病百科
  static void didNormalDisease(String diseaseType) {
    _analytics?.logEvent(
      name: EventName.normalDisease,
      parameters: {'disease_type': diseaseType},
    );
  }

  static String subscribeType(String? id) {
    // weekly，year
    if (id == 'plant_sub_vip_plan_weekly' || id == 'sub_vip_plan_weekly' || id == 'vip_plan_weekly_sub') {
      return 'weekly';
    } else if (id == 'sub_vip_plan_yearly' || id == 'plant_sub_vip_plan_yearly' || id == 'vip_plan_yearly_sub') {
      return 'year';
    }
    return '';
  }
}

/// 事件名称
class EventName {
  /// 打开登陆页面
  static const String loginPage = 'login_page';

  /// google登陆按钮
  static const String gaLoginBtn = 'ga_login_btn';

  /// google登陆成功
  static const String gaLoginSuccess = 'ga_login_success';

  /// google登陆失败
  static const String gaLoginFailure = 'ga_login_failure';

  /// 邮箱密码登陆按钮
  static const String passwordLoginBtn = 'password_login_btn';

  /// 邮箱密码登陆成功
  static const String passwordLoginSuccess = 'password_login_success';

  /// 邮箱密码登陆失败
  static const String passwordLoginFailure = 'password_login_failure';

  /// 点击Sign up发送邮箱验证
  static const String emailVerification = 'email_verification';

  /// 重发验证邮件
  static const String resendVerification = 'resend_verification';

  /// 重置密码点击‘done’
  static const String resetPassword = 'reset_password';

  /// apple登陆按钮
  static const String apLoginBtn = 'ap_login_btn';

  /// apple登陆成功
  static const String apLoginSuccess = 'ap_login_success';

  /// apple登陆失败
  static const String apLoginFailure = 'ap_login_failure';

  /// 首页点击个人中心
  static const String homeSettingBtn = 'home_setting_btn';

  /// 首页点击‘Identify’
  static const String homeIdentify = 'home_identify';

  /// 首页点击‘Dianose’
  static const String homeDianose = 'home_dianose';

  /// 首页点击底部拍照icon
  static const String homeShootBttom = 'home_shoot_buttom';

  /// 用户发起会员订阅
  static const String memberPurchaseSelect = 'member_purchase_select';

  /// 会员付款成功
  static const String memberPurchaseSuccess = 'member_purchase_success';

  /// 会员订阅界面‘restore’
  static const String subscribeRestore = 'subscribe_restore';

  /// 拍照界面点击拍照提示icon
  static const String shootHelp = 'shoot_help';

  /// 点击相册选图icon
  static const String shootAlbum = 'shoot_album';

  /// 拍照界面点击‘Dianose’
  static const String shootDianose = 'shoot_dianose';

  /// 拍照界面点击‘Identify’
  static const String shootIdentify = 'shoot_identify';

  /// 详情页点击‘save’按钮
  static const String infoSave = 'info_save';

  /// 详情页点击‘share’icon
  static const String infoShare = 'info_share';

  /// 详情页点击‘拍照’icon
  static const String infoShoot = 'info_shoot';

  /// 诊断详情页点击‘plant info’
  static const String dianoseInfoPlantinfo = 'dianose_info_plantinfo';

  /// 诊断详情页点击‘Retake’
  static const String dianoseInfoRetake = 'dianose_info_retake';

  /// 列表页点击rename
  static const String listRename = 'list_rename';

  /// 列表页点击remove
  static const String listRemove = 'list_remove';

  /// 用户remove弹窗二次确认删除
  static const String listRemoveAgree = 'list_remove_agree';

  /// 设置界面分享app
  static const String settingShareApp = 'setting_share_app';

  /// 发起订阅会员付款上报
  static const String subscribeSelect = 'subscribe_select';

  /// 常见诊断百科点击
  static const String normalDisease = 'normal_disease';

  /// 订阅会员付款成功上报
  static const String subscribeSuccess = 'subscribe_success';

  /// 诊断记录点击
  static const String diagnoseHistory = 'diagnose_history';

  /// 首页打开提醒
  static const String homeOpenReminder = 'home_open_reminder';

  /// 提醒列表添加新reminder按钮
  static const String addReminder = 'add_reminder';

  /// 具体植物底部添加reminder按钮
  static const String plantAddReminder = 'plant_add_reminder';

  /// 具体植物底部编辑reminder按钮
  static const String plantEditReminder = 'plant_edit_reminder';

  /// 首页打开光度计
  static const String homeOpenLight = 'home_open_light';

  /// 通过首页点击分类
  static const String homeCategories = 'home_categories';

  /// 首页点击搜索框
  static const String homeSearch = 'home_search';

  /// 会员订阅页面
  static const String membershipPage = 'menbership_page';

  /// 会员订阅页面点击调起支付按钮
  static const String subscribeMembershipBtn = 'subscribe_menbership_btn';

  /// 启动app弹起试用页面
  static const String openAppFreePage = 'open_app_free_page';

  /// 启动app页面点击调起支付按钮
  static const String openAppFreePageBtn = 'open_app_free_page_btn';

  /// 每日首日识别结果关闭弹起试用页面
  static const String resultCloseFreePage = 'result_close_free_page';

  /// 识别结果试用页面点击调起支付按钮
  static const String resultCloseFreePageBtn = 'result_close_free_page_btn';

  /// 非会员诊断结果页面点击底部按钮
  static const String diagnosisPurchaseBtn = 'diagnosis_perchase_btn';

  /// 拍照历史点击save按钮
  static const String snapHistorySaveBtn = 'snap_history_save_btn';

  /// 拍照历史save说明页面底部升级按钮
  static const String savePagePurchaseBtn = 'save_page_perchase_btn';

  /// 导航跳转询问专家页面
  static const String gptPage = 'gpt_page';

  /// 专家页面发送文字按钮
  static const String textSendBtn = 'text_send_btn';

  /// 点击诊断历史图标
  static const String diagnosisHistoryIcon = 'diagnosis_history_icon';
}
