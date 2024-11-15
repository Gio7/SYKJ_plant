import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plant/api/dio.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/common/rsa.dart';
import 'package:plant/pages/my_plants/my_plants_controller.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final firebaseAuth = FirebaseAuth.instance;

  // UserCredential? currentCredential;

  @override
  onInit() {
    super.onInit();
    firebaseAuth.setLanguageCode(Get.deviceLocale?.languageCode);
  }

  @override
  onClose() {
    if (firebaseAuth.currentUser != null) {
      final isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
      if (!isVerified) {
        try {
          firebaseAuth.currentUser?.delete();
        } catch (e) {
          Get.log(e.toString(), isError: true);
        }
      }
    }
    super.onClose();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'weakPassword'.tr, gravity: ToastGravity.CENTER);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'emailAlreadyInUse'.tr, gravity: ToastGravity.CENTER);
      } else if (e.code == 'network-request-failed'){
        Fluttertoast.showToast(msg: 'apiError'.tr, gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(msg: 'normalError'.tr, gravity: ToastGravity.CENTER);
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Fluttertoast.showToast(msg: 'normalError'.tr, gravity: ToastGravity.CENTER);
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  /// 刷新用户验证信息
  Future<bool> emailVerifiedReload() async {
    bool isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
    if (isVerified) {
      return true;
    }
    try {
      await firebaseAuth.currentUser?.reload();
      isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
      if (isVerified) {
        final uid = firebaseAuth.currentUser?.uid;
        if (uid != null) {
          await login(uid, firebaseAuth.currentUser?.email, type: 2);
          // Get.until((route) => Get.currentRoute == '/');
          Get.back(closeOverlays: true);
          Get.back();
          Get.back();
        }
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
    return isVerified;
  }

  Future<void> emailSend() async {
    final isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
    if (isVerified) {
      return;
    }
    await firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<void> emailCreateUser(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emailSend();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'weakPassword'.tr, gravity: ToastGravity.CENTER);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'emailAlreadyInUse'.tr, gravity: ToastGravity.CENTER);
      } else if (e.code == 'network-request-failed'){
        Fluttertoast.showToast(msg: 'apiError'.tr, gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(msg: 'normalError'.tr, gravity: ToastGravity.CENTER);
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Fluttertoast.showToast(msg: 'normalError'.tr, gravity: ToastGravity.CENTER);
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> emailSignIn(String email, String password) async {
    try {
      final currentCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = currentCredential.user?.uid;
      if (uid != null) {
        await login(uid, currentCredential.user?.email, type: 2);
        FireBaseUtil.logEvent(EventName.passwordLoginSuccess);
        Get.back(closeOverlays: true);
        Get.back();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'userNotFound'.tr, gravity: ToastGravity.CENTER);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'wrongPassword'.tr, gravity: ToastGravity.CENTER);
      } else if (e.code == 'network-request-failed'){
        Fluttertoast.showToast(msg: 'apiError'.tr, gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(msg: 'normalError'.tr, gravity: ToastGravity.CENTER);
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    } catch (e) {
      Fluttertoast.showToast(msg: 'normalError'.tr, gravity: ToastGravity.CENTER);
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> login(String uid, String? email, {required int type}) async {
    try {
      Get.dialog(const LoadingDialog());
      final uidEncode = await Rsa.encodeString(uid);
      final emailEncode = await Rsa.encodeString(email);
      final res = await Request.oneClickLogin(uidEncode, emailEncode, GlobalData.fcmToken);
      final token = res['token'];
      if (token == null || token.isEmpty) {
        throw 'token 为空';
      }

      DioUtil.token = token;
      DioUtil.resetDio();
      final userCtr = Get.find<UserController>();
      userCtr.isLogin.value = true;
      userCtr.userInfo.value = UserInfoModel.fromJson(res);
      if (Get.isRegistered<MyPlantsController>()) {
        final myPlantsCtr = Get.find<MyPlantsController>();
        if (myPlantsCtr.repository.currentTab.value.value == "1") {
          myPlantsCtr.onPlantRefresh();
        } else {
          myPlantsCtr.onReminderRefresh();
        }
      }
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', token);
      });
    } catch (e) {
      if (type == 1) {
        FireBaseUtil.logEvent(EventName.gaLoginFailure);
      } else if (type == 2) {
        FireBaseUtil.logEvent(EventName.passwordLoginSuccess);
      } else if (type == 3) {
        FireBaseUtil.logEvent(EventName.apLoginFailure);
      }
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
