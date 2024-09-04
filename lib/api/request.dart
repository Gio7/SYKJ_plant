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
  static const String _scanByScientificName = '/Plant/plant/scanByScientificName';
  static const String _getPlantDetailByRecord = '/Plant/plant/getPlantDetailByRecord';
  static const String _getShopList = '/Plant/shop/getShopList';

  /// telegram_group\email
  static Future<void> getConfig([List<String> conKey = const ['telegram_group', 'email']]) async {
    return await DioUtil.httpPost(_getConfig, data: {'conKey': conKey});
  }

  static Future<dynamic> getUploadToken() async {
    return await DioUtil.httpGet(_uploadToken);
  }

  static Future<dynamic> oneClickLogin(String uid, String? email) async {
    return await DioUtil.httpPost(_oneClickLogin, data: {'uid': uid, 'email': email});
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
  static Future<dynamic> plantDiagnosis(String url, String thumbnail) async {
    return await DioUtil.httpPost(_plantDiagnosis, data: {'url': url, 'thumbnail': thumbnail}, ignoreAll: true);
  }

  static Future<dynamic> getPlantScanHistory(int pageNum, [int pageSize = 20]) async {
    return await DioUtil.httpGet(_plantScanHistory, parameters: {'pageNum': pageNum, 'pageSize': pageSize}, allData: true);
  }

  static Future<void> plantScanRename(int id, String plantName) async {
    return await DioUtil.httpPost(_plantScanRename, data: {'plantName': plantName, 'id': id});
  }

  static Future<void> plantScanDelete(int id) async {
    return await DioUtil.httpPost(_plantScanDelete, data: {'id': id});
  }

  static Future<dynamic> scanByScientificName(String scientificName, int scanRecordId) async {
    return await DioUtil.httpPost(_scanByScientificName, data: {'scientificName': scientificName});
  }

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
}
