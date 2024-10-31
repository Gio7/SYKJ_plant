import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/common_util.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/nav_bar.dart';

class ShootPage extends StatelessWidget {
  const ShootPage({super.key, this.shootType = ShootType.identify});
  final ShootType shootType;

  @override
  Widget build(BuildContext context) {
    final ctr = Get.put(PlantController(shootType));
    final width = Get.width - 116;

    final repository = ctr.repository;

    return Container(
      color: UIColor.black,
      child: Stack(
        children: [
          Obx(
            () => Positioned.fill(
              child: (repository.isCameraReady.value) ? CameraPreview(repository.cameraController!) : const Center(child: CircularProgressIndicator()),
            ),
          ),
          Center(
            child: Image.asset(
              'images/icon/canera_border.png',
              width: width,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: NavBar(
              leftWidget: Obx(
                () => IconButton(
                  onPressed: () async {
                    ctr.toggleFlashMode();
                  },
                  icon: Image.asset(
                    repository.flashMode.value == FlashMode.off ? 'images/icon/flash_close.png' : 'images/icon/flash_open.png',
                    width: 32,
                  ),
                ),
              ),
              rightWidget: IconButton(
                onPressed: () => Get.back(),
                icon: Image.asset('images/icon/close_back.png', width: 32),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 250,
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(256),
                      ),
                    ),
                    child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: NormalButton(
                              onTap: () {
                                FireBaseUtil.logEvent(EventName.shootIdentify);
                                ctr.repository.shootType.value = ShootType.identify;
                              },
                              text: 'identify'.tr,
                              textColor: ctr.repository.shootType.value == ShootType.identify ? UIColor.primary : UIColor.white,
                              bgColor: ctr.repository.shootType.value == ShootType.identify ? UIColor.white : UIColor.transparent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: NormalButton(
                              onTap: () {
                                FireBaseUtil.logEvent(EventName.shootDianose);
                                ctr.repository.shootType.value = ShootType.diagnose;
                              },
                              text: 'diagnose'.tr,
                              textColor: ctr.repository.shootType.value == ShootType.diagnose ? UIColor.primary : UIColor.white,
                              bgColor: ctr.repository.shootType.value == ShootType.diagnose ? UIColor.white : UIColor.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FireBaseUtil.logEvent(EventName.shootAlbum);
                              ctr.didPickerPhoto();
                            },
                            child: Image.asset(
                              'images/icon/image_picker.png',
                              width: 50,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await ctr.didShootPhoto();
                            },
                            child: Image.asset(
                              ctr.repository.shootType.value == ShootType.identify ? 'images/icon/camera_search.png' : 'images/icon/camera_diagnose.png',
                              width: 70,
                            ),
                          ),
                          if (ctr.repository.shootType.value == ShootType.identify)
                            GestureDetector(
                              onTap: () {
                                FireBaseUtil.logEvent(EventName.shootHelp);
                                ctr.didShowHelp();
                              },
                              child: Image.asset(
                                'images/icon/help.png',
                                width: 50,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: Common.debounce(() {
                                ctr.diagnoseScanPhoto();
                              }),
                              child: Image.asset(
                                'images/icon/diagnose_ok.png',
                                width: 50,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (ctr.repository.shootType.value == ShootType.diagnose) {
              return Positioned(
                left: 0,
                top: (Get.height / 2) - (width / 2) - 112,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageContainer(
                      ctr.repository.diagnoseImageFile1.value,
                      onDeleteTap: () => ctr.diagnoseDeletePhoto(0),
                    ),
                    const SizedBox(width: 4),
                    _buildImageContainer(
                      ctr.repository.diagnoseImageFile2.value,
                      onDeleteTap: () => ctr.diagnoseDeletePhoto(1),
                    ),
                    const SizedBox(width: 4),
                    _buildImageContainer(
                      ctr.repository.diagnoseImageFile3.value,
                      onDeleteTap: () => ctr.diagnoseDeletePhoto(2),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  SizedBox _buildImageContainer(File? imageFile, {Function()? onDeleteTap}) {
    return SizedBox(
      width: 80,
      height: 72,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: ShapeDecoration(
                color: UIColor.white.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: UIColor.white,
                  strokeWidth: 1,
                  dash: const <int>[2, 2],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: imageFile == null
                    ? const SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      ),
              ),
            ),
          ),
          if (imageFile != null)
            Positioned(
              top: 0,
              right: 0,
              width: 24,
              height: 24,
              child: GestureDetector(
                onTap: onDeleteTap,
                child: Image.asset('images/icon/close_circle.png', width: 24, height: 24),
              ),
            ),
        ],
      ),
    );
  }
}
