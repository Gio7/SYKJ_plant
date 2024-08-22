import 'package:get/get.dart';
import 'package:plant/api/dio.dart';
import 'package:plant/api/request.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLogin = false.obs;
  var version = ''.obs;
  var userInfo = UserInfoModel().obs;

  Future<void> logout() async {
    isLogin.value = false;
    userInfo.value = UserInfoModel();
    DioUtil.token = '';
    DioUtil.resetDio();
    SharedPreferences.getInstance().then((value) async {
      value.remove('token');
      // await value.remove('draftList');
      // mcc.getDraftData();
    });
  }

  /// 显示登录
  void showLogin() {
    isLogin.value = false;
    Get.to(() => const LoginPage(), fullscreenDialog: true);
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((info) {
      version.value = "V${info.version}";
    });
  }

  Future<void> getUserInfo() async {
    if (DioUtil.token.isBlank ?? true) {
      isLogin.value = false;
      return;
    } else {
      isLogin.value = true;
    }
    final res = await Request.userinfo();
    final String? token = res['token'];
    if (token != null && token.isNotEmpty) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', token);
      });
    }
    userInfo.value = UserInfoModel.fromJson(res);
  }

  Future<void> userEdit(String nickname) async {
    await Request.userEdit(nickname);
    final u = userInfo.value.toMap();
    u['nickname'] = nickname;
    userInfo.value = UserInfoModel.fromJson(u);
  }

  Future<void> userDelete() async {
    await Request.userDelete();
    logout();
  }
}
