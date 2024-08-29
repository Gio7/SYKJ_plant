import 'dart:async';
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

  Future<bool> requestInfo(Completer<void> completer, File cropFile, File image400File) async {
    await uploadFile(completer, cropFile, image400File);
    if (completer.isCompleted) return false;
    if (image400Url == null || thumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    dynamic res;
    if (shootType.value == 'identify') {
      res = await Request.plantScan(image400Url!, thumbnailUrl!);
    } else {
      res = await Request.plantDiagnosis(image400Url!, thumbnailUrl!);
    }
    if (completer.isCompleted) return false;
    if (res.statusCode == 200) {
      final responseData = res.data;
      if (responseData['code'] == 200 || responseData['code'] == 0) {
        isIdentifyingPlant.value = true;
        try {
          if (shootType.value == 'identify') {
            plantInfo = PlantInfoModel.fromJson(responseData['data']);
            Get.off(() => InfoIdentifyPage());
          } else {
            diagnoseInfo = PlantDiagnosisModel.fromJson(responseData['data']);
            Get.off(() => InfoDiagnosePage());
          }
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

  Future<void> uploadFile(Completer<void> completer, File cropFile, File image400File) async {
    image400Url = null;
    thumbnailUrl = null;
    isAnalyzingImage.value = false;
    isDetectingLeaves.value = false;
    isIdentifyingPlant.value = false;
    image400Url = await AwsUtils.uploadByFile(image400File);
    if (completer.isCompleted) return;
    thumbnailUrl = await AwsUtils.uploadByFile(cropFile);
    if (completer.isCompleted) return;
    isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (completer.isCompleted) return;
      isDetectingLeaves.value = true;
    });
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
