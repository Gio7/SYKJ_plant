import 'dart:async';

import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:light/light.dart';
import 'package:plant/widgets/show_dialog.dart';

part 'light_repository.dart';

class LightController extends GetxController {
  final LightRepository repository = LightRepository();

  StreamSubscription? _subscriptionAndroid;

  @override
  void onInit() {
    super.onInit();
    if(GetPlatform.isAndroid) {
      startAndroidListening();
    } else {
      initCamera();
    }
  }

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
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      repository.cameraController = CameraController(
        frontCamera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
    } catch (e) {
      Get.log('cameras init error:$e', isError: true);
      Get.dialog(
        barrierDismissible: true,
        NormalDialog(
          title: 'deviceNotDetected'.tr,
          confirmText: 'ok',
          onConfirm: () {
            // Get.until((route) => Get.currentRoute == '/');
            Get.back(closeOverlays: true);
          },
        ),
      );
    }
    try {
      await repository.cameraController?.initialize();
      repository.isCameraReady.value = true;
      repository.cameraController?.lockCaptureOrientation();
      repository.cameraController?.startImageStream((CameraImage image) {
        repository.lux.value = _calculateLuxFromBrightness(image);
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

  // 根据亮度估算 lux 值
  int _calculateLuxFromBrightness(CameraImage image) {
    double totalBrightness = 0.0;
    int pixelCount = 0;

    final plane = image.planes[0]; // YUV 图像的亮度平面

    for (int i = 0; i < plane.bytes.length; i++) {
      int brightnessValue = plane.bytes[i] & 0xFF; // 确保亮度值在 0-255 范围内

      // 忽略亮度值为 255 的像素
      if (brightnessValue == 255) continue;

      totalBrightness += brightnessValue;
      pixelCount++;
    }

    // 防止除以0的情况
    if (pixelCount == 0) return 0;

    final averageBrightness = totalBrightness / pixelCount;

    // 使用一个比例常量来转换为 lux
    const double brightnessToLuxRatio = 2.5; // 实验性常量，可调节以提高精度
    return (averageBrightness * brightnessToLuxRatio).toInt();
  }
}
