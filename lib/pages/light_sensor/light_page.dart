import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';

import 'light_sensor_controller.dart';

class LightPage extends StatelessWidget {
  LightPage({super.key});

  final lightController = Get.put(LightSensorController());
  final mediaQueryTop = Get.mediaQuery.padding.top;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('images/icon/light_bg.png', fit: BoxFit.cover)),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          _buildNav,
          Positioned(
            left: 0,
            right: 0,
            top: mediaQueryTop + 86,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'lightTopTips'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            ),
          ),
          Positioned(
            top: mediaQueryTop + 166,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/icon/light_center.png',
              width: 290,
              height: 290,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIOS() {
    lightController.initCamera();
    final repository = lightController.repository;
    return Stack(
      children: [
        Image.asset('images/icon/light_bg.png', fit: BoxFit.cover),
        Obx(
          () => Positioned(
            left: 0,
            right: 0,
            top: 0,
            // height: 300,
            child: repository.isCameraReady.value ? CameraPreview(repository.cameraController!) : const Center(child: CircularProgressIndicator()),
          ),
        ),
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          height: 200,
          child: Obx(
            () => Text(
              '${repository.lux.value}',
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid() {
    final repository = lightController.repository;
    return Column(
      children: [
        Obx(
          () => Text(
            '${repository.lux.value}',
            style: const TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            lightController.startAndroidListening();
          },
          child: const Text('start'),
        )
      ],
    );
  }

  Widget get _buildNav {
    return Positioned(
      top: 0,
      left: 24,
      right: 24,
      height: 56 + mediaQueryTop,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  'images/icon/info.png',
                  width: 24,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  'images/icon/close_transparent.png',
                  width: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
