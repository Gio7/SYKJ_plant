import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/aws_utils.dart';
import 'package:plant/pages/info_diagnose_page.dart';
import 'package:plant/pages/info_identify_page.dart';

class IdentifyController extends GetxController {
  /// 识别类型 identify diagnose
  RxString shootType = 'identify'.obs;
  String? originalUrl;
  String? thumbnailUrl;
  RxBool isAnalyzingImage = false.obs;
  RxBool isDetectingLeaves = false.obs;
  RxBool isIdentifyingPlant = false.obs;

  dynamic plantInfo;

  Future<bool> requestInfo(File cropFile, File originalFile) async {
    if (shootType.value == 'identify') {
      return await plantScan(cropFile, originalFile);
    } else {
      return await plantDiagnosis(originalFile);
    }
  }

  Future<void> uploadFile(File? cropFile, File originalFile) async {
    originalUrl = await AwsUtils.uploadByFile(originalFile);
    if (cropFile != null) {
      thumbnailUrl = await AwsUtils.uploadByFile(cropFile);
    }
    isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isDetectingLeaves.value = true;
    });
  }

  Future<bool> plantScan(File cropFile, File originalFile) async {
    await uploadFile(cropFile, originalFile);

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
        Get.off(const InfoIdentifyPage());
        // 成功
        return true;
      }
    }
    Get.log(res.toString());
    return false;
  }

  Future<bool> plantDiagnosis(File originalFile) async {
    await uploadFile(null, originalFile);

    if (originalUrl == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败');
      return false;
    }
    final res = await Request.plantDiagnosis(originalUrl!);

    if (res.statusCode == 200) {
      final responseData = res.data;
      if (responseData['code'] == 200 || responseData['code'] == 0) {
        isIdentifyingPlant.value = true;
        plantInfo = responseData['data'];
        Get.log(plantInfo.toString());
        Get.off(const InfoDiagnosePage());
        // 成功
        return true;
      }
    }
    Get.log(res.toString());
    return false;
  }
}
