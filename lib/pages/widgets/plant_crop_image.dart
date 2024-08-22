import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/nav_bar.dart';
import 'package:plant/pages/scan_page.dart';

class PlantCropImage extends StatelessWidget {
  const PlantCropImage({super.key, required this.imageData});
  final Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    final controller = CropController();
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Crop(
                willUpdateScale: (newScale) => newScale < 5,
                controller: controller,
                image: imageData,
                onCropped: (croppedData) {
                  Get.back();
                  Get.off(() => ScanPage(photoImage: croppedData));
                },
                withCircleUi: false,
                onStatusChanged: (status) {
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
              height: 120,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => controller.crop(),
                child: Image.asset(
                  'images/icon/check.png',
                  width: 60,
                ),
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
    );
  }
}
