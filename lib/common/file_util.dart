import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtil {
  static Future<void> download(String url) async {
    if (!(await _checkPermission())) {
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    var appDocDir = '';
    if (GetPlatform.isIOS) {
      appDocDir = (await getApplicationDocumentsDirectory()).path;
    } else {
      appDocDir = ((await getExternalStorageDirectory()) ?? (await getApplicationDocumentsDirectory())).path;
    }
    String savePath = '$appDocDir/${url.split('/').last}';
    try {
      final resp = await Dio().download(
        url,
        savePath,
        // onReceiveProgress: onReceiveProgress,
        options: Options(
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      if (resp.statusCode == 200) {
        Get.log('下载成功');
        Get.back();
        if (GetPlatform.isAndroid) {
          Get.snackbar('downloadComplete'.tr, 'Directory：$savePath', duration: const Duration(seconds: 5));
        } else {
          Fluttertoast.showToast(msg: 'downloadComplete'.tr, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
        }
      } else {
        Get.back();
        Get.snackbar('error', 'download failed');
        Get.log('下载失败');
      }
      /* ,queryParameters: queryParams,cancelToken: cancelToken,onReceiveProgress: (count,total){
        print("-------------------->下载进度：${count/total}");
      }*/
    } catch (e) {
      Get.back();
      Get.log(e.toString());
      Get.snackbar('error', e.toString());
      rethrow;
    }
  }

  static Future<bool> _checkPermission() async {
    if (GetPlatform.isIOS) {
      return true;
    }
    if (GetPlatform.isAndroid) {
      final status = await Permission.storage.request();
      switch (status) {
        case PermissionStatus.granted:
          return true;
        case PermissionStatus.denied:
          Get.snackbar('error', 'No storage permission');
          break;
        case PermissionStatus.permanentlyDenied:
          Get.snackbar('error', 'No storage permission');
          break;
        default:
          break;
      }
    }

    return false;
  }
}
