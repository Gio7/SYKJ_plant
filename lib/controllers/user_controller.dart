import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plant/api/dio.dart';
import 'package:plant/common/date_util.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLogin = false.obs;
  var version = ''.obs;
  var userInfo = UserInfoModel().obs;

  // Future<bool> login() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //     Get.back();
  //     Get.dialog(const LoadingDialog());

  //     /// id 加密 RSA
  //     /// 邮箱和ID加密
  //     final id = await Rsa.encodeString(credential.userIdentifier ?? '');
  //     final email = await Rsa.encodeString(credential.email);
  //     final token = await LabRequest.appleLogin(
  //       tokin: credential.identityToken ?? '',
  //       id: id,
  //       email: email,
  //     );
  //     DioUtil.token = token;
  //     DioUtil.resetDio();
  //     isLogin.value = true;
  //     Get.back();
  //     Fluttertoast.showToast(msg: 'loginSuccessful'.tr);
  //     SharedPreferences.getInstance().then((prefs) {
  //       prefs.setString('token', token);
  //       prefs.remove('draftList');
  //     });
  //     getUserInfo();
  //     Get.find<MusicCollectionController>().onRefresh();
  //     return true;
  //   } catch (e) {
  //     if (e is SignInWithAppleAuthorizationException) {
  //       Fluttertoast.showToast(msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
  //     }
  //     return false;
  //   }
  // }

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
    // final u = await Request.userInfo();
    // userInfo.value = u;
  }

  String get proExpirationDate {
    if (userInfo.value.expireTime == null) return '';
    return DateUtil.formatMilliseconds(userInfo.value.expireTime, format: DateFormat.yMd());
  }
}
