import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plant/api/dio.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:plant/pages/login/login_page.dart';
import 'package:plant/pages/my_plants/my_plants_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLogin = false.obs;
  var userInfo = UserInfoModel().obs;

  Future<void> logout() async {
    isLogin.value = false;
    userInfo.value = UserInfoModel();
    DioUtil.token = '';
    DioUtil.resetDio();
    if (Get.isRegistered<MyPlantsController>()) {
      final myPlantsCtr = Get.find<MyPlantsController>();
      myPlantsCtr.repository.plantDataList.value = [];
      myPlantsCtr.repository.reminderDataList.value = [];
    }
    SharedPreferences.getInstance().then((value) async {
      value.remove('token');
    });
  }

  /// 显示登录
  void showLogin() {
    isLogin.value = false;
    FireBaseUtil.loginPageEvent(Get.currentRoute);
    Get.to(() => const LoginPage(), fullscreenDialog: true, routeName: 'login_page');
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
    if (!userInfo.value.pushToken && GlobalData.fcmToken != null) {
      Future.delayed(const Duration(seconds: 5), () {
        Request.updatePushToken(GlobalData.fcmToken!);
      });
    }
  }

  Future<void> userEdit(String nickname) async {
    await Request.userEdit(nickname);
    final u = userInfo.value.toMap();
    u['nickname'] = nickname;
    userInfo.value = UserInfoModel.fromJson(u);
  }

  Future<void> userDelete() async {
    await Request.userDelete();
    FirebaseAuth.instance.currentUser?.delete();
    logout();
  }
}
