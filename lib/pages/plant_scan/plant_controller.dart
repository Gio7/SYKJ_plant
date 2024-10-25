import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/aws_utils.dart';
import 'package:plant/models/plant_diagnosis_model.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/pages/plant_scan/info_diagnose_page.dart';
import 'package:plant/pages/plant_scan/info_identify_page.dart';

part 'plant_repository.dart';

class PlantController extends GetxController {
  final PlantRepository repository = PlantRepository();

  Future<bool> requestInfo(Completer<void> completer, File imageThumbnailFile, File image400File) async {
    repository.plantInfo = null;
    repository.diagnoseInfo = null;
    await uploadFile(completer, imageThumbnailFile, image400File);
    if (completer.isCompleted) return false;
    if (repository.identifyImage400Url == null || repository.identifyThumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    dynamic res;
    if (repository.shootType.value == ShootType.identify) {
      res = await Request.plantScan(repository.identifyImage400Url!, repository.identifyThumbnailUrl!);
    } else {
      res = await Request.plantDiagnosis(repository.identifyImage400Url!, repository.identifyThumbnailUrl!);
    }
    if (completer.isCompleted) return false;
    if (res.statusCode == 200) {
      final responseData = res.data;
      if (responseData['code'] == 200 || responseData['code'] == 0) {
        repository.isIdentifyingPlant.value = true;
        try {
          if (repository.shootType.value == ShootType.identify) {
            repository.plantInfo = PlantInfoModel.fromJson(responseData['data']);
            Get.off(() => InfoIdentifyPage());
          } else {
            repository.diagnoseInfo = PlantDiagnosisModel.fromJson(responseData['data']);
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

  Future<void> uploadFile(Completer<void> completer, File imageThumbnailFile, File image400File) async {
    repository.identifyImage400Url = null;
    repository.identifyThumbnailUrl = null;
    repository.isAnalyzingImage.value = false;
    repository.isDetectingLeaves.value = false;
    repository.isIdentifyingPlant.value = false;
    repository.identifyImage400Url = await AwsUtils.uploadByFile(image400File);
    if (completer.isCompleted) return;
    repository.identifyThumbnailUrl = await AwsUtils.uploadByFile(imageThumbnailFile);
    if (completer.isCompleted) return;
    repository.isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (completer.isCompleted) return;
      repository.isDetectingLeaves.value = true;
    });
  }

  Future<void> scanByScientificName(int id) async {
    try {
      final res = await Request.getPlantDetailByRecord(id);
      repository.plantInfo = PlantInfoModel.fromJson(res);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> savePlant(int id) async {
    await Request.scanSave(id);
  }
}
