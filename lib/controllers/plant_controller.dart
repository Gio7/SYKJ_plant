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
  /// 压缩到 400* 400
  String? image400Url;
  /// 需要压缩质量
  String? thumbnailUrl;
  RxBool isAnalyzingImage = false.obs;
  RxBool isDetectingLeaves = false.obs;
  RxBool isIdentifyingPlant = false.obs;

  PlantInfoModel? plantInfo;
  PlantDiagnosisModel? diagnoseInfo;

  // 是否已经返回
  bool haveReturned = false;

  Future<bool> requestInfo(File cropFile, File image400File) async {
    if (shootType.value == 'identify') {
      return await plantScan(cropFile, image400File);
    } else {
      return await plantDiagnosis(cropFile, image400File);
    }
  }

  Future<void> uploadFile(File cropFile, File image400File) async {
    image400Url = null;
    thumbnailUrl = null;
    isAnalyzingImage.value = false;
    isDetectingLeaves.value = false;
    isIdentifyingPlant.value = false;
    image400Url = await AwsUtils.uploadByFile(image400File);
    thumbnailUrl = await AwsUtils.uploadByFile(cropFile);
    isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      isDetectingLeaves.value = true;
    });
  }

  Future<bool> plantScan(File cropFile, File image400File) async {
    await uploadFile(cropFile, image400File);

    if (image400Url == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    final res = await Request.plantScan(image400Url!, thumbnailUrl!);
    if (haveReturned) return true;
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

  Future<bool> plantDiagnosis(File cropFile, File image400File) async {
    await uploadFile(cropFile, image400File);

    if (image400Url == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    final res = await Request.plantDiagnosis(image400Url!, thumbnailUrl!);
    if (haveReturned) return true;
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
