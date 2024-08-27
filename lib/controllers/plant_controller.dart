import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/aws_utils.dart';
import 'package:plant/models/plant_diagnosis_model.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/pages/info_diagnose_page.dart';
import 'package:plant/pages/info_identify_page.dart';

class PlantController extends GetxController {
  /// 识别类型 identify diagnose
  RxString shootType = 'identify'.obs;
  String? originalUrl;
  String? thumbnailUrl;
  RxBool isAnalyzingImage = false.obs;
  RxBool isDetectingLeaves = false.obs;
  RxBool isIdentifyingPlant = false.obs;

  PlantInfoModel? plantInfo;
  PlantDiagnosisModel? diagnoseInfo;

  Future<bool> requestInfo(File cropFile, File originalFile) async {
    if (shootType.value == 'identify') {
      return await plantScan(cropFile, originalFile);
    } else {
      return await plantDiagnosis(cropFile, originalFile);
    }
  }

  Future<void> uploadFile(File cropFile, File originalFile) async {
    originalUrl = null;
    thumbnailUrl = null;
    isAnalyzingImage.value = false;
    isDetectingLeaves.value = false;
    isIdentifyingPlant.value = false;
    originalUrl = await AwsUtils.uploadByFile(originalFile);
    thumbnailUrl = await AwsUtils.uploadByFile(cropFile);
    isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isDetectingLeaves.value = true;
    });
  }

  Future<bool> plantScan(File cropFile, File originalFile) async {
    await uploadFile(cropFile, originalFile);

    if (originalUrl == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    final res = await Request.plantScan(originalUrl!, thumbnailUrl!);

    if (res.statusCode == 200) {
      final responseData = res.data;
      if (responseData['code'] == 200 || responseData['code'] == 0) {
        try {
          isIdentifyingPlant.value = true;
          plantInfo = PlantInfoModel.fromJson(responseData['data']);
          Get.off(() => InfoIdentifyPage());
          // 成功
          return true;
        } catch (e) {
          Get.log(e.toString(), isError: true);
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> plantDiagnosis(File cropFile, File originalFile) async {
    await uploadFile(cropFile, originalFile);

    if (originalUrl == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    final res = await Request.plantDiagnosis(originalUrl!, thumbnailUrl!);

    if (res.statusCode == 200) {
      final responseData = res.data;
      if (responseData['code'] == 200 || responseData['code'] == 0) {
        try {
          isIdentifyingPlant.value = true;
          diagnoseInfo = PlantDiagnosisModel.fromJson(responseData['data']);
          Get.off(() => InfoDiagnosePage());
          // 成功
          return true;
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }

  Future<void> scanByScientificName(String scientificName, int id) async {
    try {
      final res = await Request.scanByScientificName(scientificName, id);
      plantInfo = PlantInfoModel.fromJson(res);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> savePlant(int id) async {
    await Request.scanSave(id);
  }
}
