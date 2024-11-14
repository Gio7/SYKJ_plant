import 'package:plant/api/dio.dart';

class Request {
  static const String _oneClickLogin = '/Plant/user/oneClickLogin';
  static const String _userinfo = '/Plant/user/userinfo';
  static const String _userEdit = '/Plant/user/edit';
  static const String _userDelete = '/Plant/user/delete';
  static const String _uploadToken = '/Plant/common/uploadToken';
  static const String _plantScan = '/Plant/plant/scan';
  static const String _plantDiagnosis = '/Plant/plant/diagnosis';
  static const String _plantScanHistory = '/Plant/plant/scanHistory';
  static const String _scanSave = '/Plant/plant/scanSave';
  static const String _plantScanRename = '/Plant/plant/scanRename';
  static const String _plantScanDelete = '/Plant/plant/scanDelete';
  static const String _getConfig = '/Plant/common/getConfig';

  // static const String _scanByScientificName = '/Plant/plant/scanByScientificName';
  static const String _getPlantDetailByRecord = '/Plant/plant/getPlantDetailByRecord';
  static const String _getShopList = '/Plant/shop/getShopList';
  static const String _createOrder = '/Plant/shop/createOrder';
  static const String _verifyOrder = '/Plant/shop/verifyOrder';
  static const String _exchangeGift = '/Plant/shop/exchangeGift';
  static const String _getOrderKey = '/Plant/shop/getOrderKey';
  static const String _diagnosisHistory = '/Plant/plant/diagnosisHistory';
  static const String _diagnosisHistoryDetail = '/Plant/plant/diagnosisHistoryDetail';
  static const String _getDiseaseHome = '/Plant/plant/getDiseaseHome';

  /// 获取搜索分类列表
  static const String _getSearchList = '/Plant/home/getSearchList';
  static const String _plantSearch = '/Plant/home/search';
  static const String _getPlantByUniqueId = '/Plant/plant/getPlantByUniqueId';
  static const String _updatePushToken = '/Plant/user/updatePushToken';
  static const String _getReminders = '/Plant/plant/getReminders';
  static const String _plantAlarmUpdate = '/Plant/alarm/update';
  static const String _plantAlarmDelete = '/Plant/alarm/delete';
  static const String _plantPlantQuestion = '/Plant/plant/question';

  /// telegram_group\email
  static Future<void> getConfig([List<String> conKey = const ['telegram_group', 'email']]) async {
    return await DioUtil.httpPost(_getConfig, data: {'conKey': conKey});
  }

  static Future<dynamic> getUploadToken() async {
    return await DioUtil.httpGet(_uploadToken);
  }

  static Future<dynamic> oneClickLogin(String uid, String? email, String? pushToken) async {
    return await DioUtil.httpPost(_oneClickLogin, data: {'uid': uid, 'email': email, 'pushToken': pushToken ?? ''});
  }

  static Future<dynamic> userinfo() async {
    return await DioUtil.httpGet(_userinfo);
  }

  static Future<void> userEdit(String nickname) async {
    return await DioUtil.httpPost(_userEdit, data: {'nickname': nickname});
  }

  static Future<void> userDelete() async {
    return await DioUtil.httpPost(_userDelete, data: {});
  }

  /// 200 正确， 201 不是植物  404 失败
  static Future<dynamic> plantScan(String url, String thumbnail) async {
    return await DioUtil.httpPost(_plantScan, data: {'url': url, 'thumbnail': thumbnail}, ignoreAll: true);
  }

  /// 200 正确， 201 不是植物  404 失败
  static Future<dynamic> plantDiagnosis(List<String?> imageUrls) async {
    return await DioUtil.httpPost(_plantDiagnosis, data: {'url': imageUrls}, ignoreAll: true);
  }

  static Future<dynamic> getPlantScanHistory(int pageNum, {int pageSize = 20, String type = "save"}) async {
    return await DioUtil.httpGet(
      _plantScanHistory,
      parameters: {'pageNum': pageNum, 'pageSize': pageSize, 'type': type},
      allData: true,
    );
  }

  static Future<void> plantScanRename(int id, String plantName) async {
    return await DioUtil.httpPost(_plantScanRename, data: {'plantName': plantName, 'id': id});
  }

  static Future<void> plantScanDelete(int id) async {
    return await DioUtil.httpPost(_plantScanDelete, data: {'id': id});
  }

  // static Future<dynamic> scanByScientificName(String scientificName, int scanRecordId) async {
  //   return await DioUtil.httpPost(_scanByScientificName, data: {'scientificName': scientificName});
  // }

  static Future<void> scanSave(int id) async {
    await DioUtil.httpPost(_scanSave, data: {'id': id});
  }

  static Future<dynamic> getPlantDetailByRecord(int id) async {
    return await DioUtil.httpPost(_getPlantDetailByRecord, data: {'scanRecordId': id});
  }

  /// 查询商品列表
  ///
  /// [type]: 0 会员商品
  static Future<List<dynamic>> getShopList(String type) async {
    return await DioUtil.httpGet(_getShopList, parameters: {"type": type});
  }

  /// 创建订单
  static Future<dynamic> createOrder(String shopId) async {
    return await DioUtil.httpPost(_createOrder, data: {"shopId": shopId});
  }

  /// 验证订单
  static Future<dynamic> verifyOrder(String data, int timeStamp) async {
    return await DioUtil.httpPost(_verifyOrder, data: {"data": data, "timeStamp": timeStamp}, ignore208: true);
  }

  static Future<dynamic> exchangeGift(String cdkey) async {
    return await DioUtil.httpPost(_exchangeGift, data: {"cdkey": cdkey});
  }

  static Future<String> getOrderKey() async {
    return await DioUtil.httpGet(_getOrderKey);
  }

  static Future<dynamic> diagnosisHistory(int pageNum, [int pageSize = 30]) async {
    return await DioUtil.httpGet(
      _diagnosisHistory,
      parameters: {'pageNum': pageNum, 'pageSize': pageSize},
      allData: true,
    );
  }

  static Future<dynamic> diagnosisHistoryDetailById(int id) async {
    return await DioUtil.httpGet(_diagnosisHistoryDetail, parameters: {'id': id});
  }

  static Future<List<dynamic>> getDiseaseHome() async {
    final res = await DioUtil.httpGet(_getDiseaseHome);
    return res['categorizedFeeds'];
  }

  /// 获取搜索分类列表
  static Future<List<dynamic>> getSearchList() async {
    final res = await DioUtil.httpGet(_getSearchList);
    return res;
  }

  /// 搜索植物
  /// "content": "apple", //全局搜索内容
  /// "categoryId": "bk6cyz53", //分类ID
  /// "type": 1 //0=分类搜索 1=全局
  static Future<List<dynamic>> plantSearch(String content, {String? categoryId, int type = 1}) async {
    try {
      final res = await DioUtil.httpPost(_plantSearch, data: {"content": content, "categoryId": categoryId, "type": type});
      if (res is List) {
        return res;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// 通过uniqueId获取植物信息
  static Future<dynamic> getPlantByUniqueId(String uniqueId) async {
    return await DioUtil.httpPost(_getPlantByUniqueId, data: {"uniqueId": uniqueId});
  }

  static void updatePushToken(String pushToken) {
    DioUtil.httpPost(_updatePushToken, data: {"pushToken": pushToken});
  }

  static Future<dynamic> getReminders(int pageNum, [int pageSize = 30]) async {
    return await DioUtil.httpGet(_getReminders, parameters: {'pageNum': pageNum, 'pageSize': pageSize}, allData: true);
  }

  static Future<void> plantAlarmUpdate({
    required int recordId,
    required int type,
    required int cycle,
    required String unit,
    required String clock,
    required String previous,
    required bool status,
  }) async {
    final data = {
      "recordId": recordId,
      "type": type,
      "cycle": cycle,
      "unit": unit,
      "clock": clock,
      "previous": previous,
      "status": status,
    };
    return await DioUtil.httpPost(_plantAlarmUpdate, data: data);
  }

  static Future<void> plantAlarmDelete(int recordId, int type) async {
    return await DioUtil.httpPost(_plantAlarmDelete, data: {"recordId": recordId, "type": type});
  }

  static Future<String> plantPlantQuestion(String text) async {
    return await DioUtil.httpPost(_plantPlantQuestion, data: {"text": text});
  }
}
