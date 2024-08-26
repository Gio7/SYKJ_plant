import 'package:plant/api/dio.dart';

class Request {
  static const String _oneClickLogin = '/Plant/user/oneClickLogin';
  static const String _userinfo = '/Plant/user/userinfo';
  static const String _userEdit = '/Plant/user/edit';
  static const String _userDelete = '/Plant/user/delete';
  static const String _uploadToken = '/Plant/common/uploadToken';
  static const String _plantScan = '/Plant/plant/scan';

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

  static Future<dynamic> plantScan(String url, String thumbnail) async {
    return await DioUtil.httpPost(_plantScan, data: {'url': url, 'thumbnail': thumbnail});
  }
}
