import 'package:get/get.dart';
import 'package:plant/api/dio.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/rsa.dart';
import 'package:plant/components/loading_dialog.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Future<void> login(String uid, String? email) async {
    try {
      Get.dialog(const LoadingDialog());
      final uidEncode = await Rsa.encodeString(uid);
      final emailEncode = await Rsa.encodeString(email);
      final res = await Request.oneClickLogin(uidEncode, emailEncode);
      final token = res['token'];
      if (token == null || token.isEmpty) {
        throw 'token 为空';
      }
      
      DioUtil.token = token;
      DioUtil.resetDio();
      final userCtr = Get.find<UserController>();
      userCtr.isLogin.value = true;
      userCtr.userInfo.value = UserInfoModel.fromJson(res);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', token);
      });
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
