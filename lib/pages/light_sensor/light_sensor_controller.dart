import 'dart:async';

import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:light/light.dart';
import 'package:plant/widgets/show_dialog.dart';

part 'light_repository.dart';

class LightSensorController extends GetxController {
  final LightRepository repository = LightRepository();

  StreamSubscription? _subscriptionAndroid;

  @override
  void onClose() {
    _subscriptionAndroid?.cancel();
    repository.cameraController?.dispose();
    super.onClose();
  }

  void startAndroidListening() async {
    final light = Light();
    try {
      _subscriptionAndroid = light.lightSensorStream.listen((v) {
        repository.lux.value = v;
      });
    } on LightException catch (exception) {
      Get.log('light exception: $exception');
    }
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      repository.cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await repository.cameraController!.initialize();
      repository.isCameraReady.value = true;
      repository.cameraController?.startImageStream((CameraImage image) {
        repository.lux.value = _calculateAverageBrightness(image);
      });
    } catch (e) {
      Get.log(e.toString(), isError: true);
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          case 'CameraAccessDeniedWithoutPrompt':
          case 'CameraAccessRestricted':
          case 'AudioAccessDenied':
          case 'AudioAccessDeniedWithoutPrompt':
          case 'AudioAccessRestricted':
            NormalDialog.showPermission();
            break;
          default:
            Fluttertoast.showToast(msg: e.toString());
            break;
        }
      }
    }
  }

  int _calculateAverageBrightness(CameraImage image) {
    double totalBrightness = 0.0;
    int pixelCount = 0;

    final plane = image.planes[0]; // 只处理 Y 平面 (亮度信息)

    // 遍历 Y 平面的每个字节
    for (int i = 0; i < plane.bytes.length; i++) {
      int brightnessValue = plane.bytes[i] & 0xFF; // 将无符号字节转为 int

      // 忽略亮度值为 255 的像素
      if (brightnessValue == 255) continue;

      totalBrightness += brightnessValue;
      pixelCount++;
    }

    // 防止除以0的情况
    if (pixelCount == 0) return 0;

    // 返回亮度的平均值
    return (totalBrightness / pixelCount).toInt();
  }
}
