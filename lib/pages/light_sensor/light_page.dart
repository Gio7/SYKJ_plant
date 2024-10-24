import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'light_sensor_controller.dart';

class LightPage extends StatelessWidget {
  LightPage({super.key});

  final lightController = Get.put(LightSensorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetPlatform.isAndroid ? _buildAndroid() : _buildIOS(),
    );
  }

  Widget _buildIOS() {
    lightController.initCamera();
    final repository = lightController.repository;
    return Stack(
      children: [
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
}
