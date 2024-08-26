import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/aws_utils.dart';

class IdentifyController extends GetxController {
  /// 识别类型 identify diagnose
  RxString shootType = 'identify'.obs;
  String? originalUrl;
  String? thumbnailUrl;
  RxBool isAnalyzingImage = false.obs;
  RxBool isDetectingLeaves = false.obs;
  RxBool isIdentifyingPlant = false.obs;

  dynamic plantInfo;

  Future<bool> uploadFile(File cropFile, File originalFile) async {
    originalUrl = await AwsUtils.uploadByFile(originalFile);
    thumbnailUrl = await AwsUtils.uploadByFile(cropFile);
    isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isDetectingLeaves.value = true;
    });
    return plantScan();
  }

  Future<bool> plantScan() async {
    if (originalUrl == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败');
      return false;
    }
    final res = await Request.plantScan(originalUrl!, thumbnailUrl!);

    if (res.statusCode == 200) {
      final responseData = res.data;
      if (responseData['code'] == 200 || responseData['code'] == 0) {
        isIdentifyingPlant.value = true;
        plantInfo = responseData['data'];
        Get.log(plantInfo.toString());
        // 成功
        return true;
      }
    }
    Get.log(res.toString());
    return false;
  }
}
