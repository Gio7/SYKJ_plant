import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:plant/common/file_utils.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/loading_dialog.dart';
import 'package:plant/components/nav_bar.dart';
import 'package:plant/pages/scan_page.dart';

class PlantCropImage extends StatelessWidget {
  const PlantCropImage({super.key, required this.originalFile});
  final File originalFile;

  @override
  Widget build(BuildContext context) {
    final controller = CropController();
    return Container(
      color: UIColor.transparent40,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Crop(
                  willUpdateScale: (newScale) => newScale < 5,
                  controller: controller,
                  image: originalFile.readAsBytesSync(),
                  onCropped: (data) async {
                    List<int> jpegBytes = img.encodeJpg(img.decodeImage(data)!, quality: 60);
                    final croppedData = Uint8List.fromList(jpegBytes);
                    final cropFile = await FileUtils.listToFile(croppedData);
                    if (cropFile == null) {
                      Get.back();
                      return;
                    }
                    final cropImage = img.decodeImage(croppedData);
                    if (cropImage == null) {
                      Get.back();
                      return;
                    }
                    final image400 = img.copyResize(cropImage, width: 400, height: 400);
                    final image400File = await FileUtils.imageToFile(image400);
                    if (image400File == null) {
                      Get.back();
                      return;
                    }
                    if (Get.isDialogOpen == true) {
                      Get.back();
                    }
                    Get.off(() => ScanPage(cropFile: cropFile, image400File: image400File));
                  },
                  withCircleUi: false,
                  onStatusChanged: (status) {
                    // if (status == CropStatus.cropping) {
                    //   Get.back();
                    // }
                    debugPrint(<CropStatus, String>{
                          CropStatus.nothing: 'Crop has no image data',
                          CropStatus.loading: 'Crop is now loading given image',
                          CropStatus.ready: 'Crop is now ready!',
                          CropStatus.cropping: 'Crop is now cropping image',
                        }[status] ??
                        '');
                  },
                  initialSize: 1,
                  baseColor: UIColor.black,
                  maskColor: UIColor.transparent40,
                  cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(),
                  interactive: true,
                  fixCropRect: true,
                  radius: 20,
                  initialRectBuilder: (viewportRect, imageRect) {
                    final w = viewportRect.right - 116;
                    return Rect.fromCenter(center: Offset(viewportRect.width / 2, viewportRect.height / 2), width: w, height: w);
                  },
                ),
              ),
              Container(
                color: UIColor.black,
                height: 150,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'placeThePlantInTheCenter'.tr,
                      style: const TextStyle(
                        color: UIColor.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(const LoadingDialog());
                        controller.crop();
                      },
                      child: Image.asset(
                        'images/icon/check.png',
                        width: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          NavBar(
            leftWidget: IconButton(
              onPressed: () => Get.back(),
              icon: const ImageIcon(
                AssetImage('images/icon/close.png'),
                size: 32,
                color: UIColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
