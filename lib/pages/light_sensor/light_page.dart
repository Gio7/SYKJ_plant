import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/widgets/show_dialog.dart';

import 'light_controller.dart';

class LightPage extends StatelessWidget {
  LightPage({super.key});

  final lightController = Get.put(LightController());
  final mediaQueryTop = Get.mediaQuery.padding.top;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetPlatform.isAndroid ? _buildAndroid : _buildIos,
    );
  }

  Widget get _buildIos {
    return Stack(
      children: [
        Positioned.fill(
          child: Obx(
            () {
              if (lightController.repository.isCameraReady.value) {
                final scale =
                    1 / (lightController.repository.cameraController!.value.aspectRatio * Get.size.aspectRatio);
                return Transform.scale(
                  scale: scale,
                  child: Center(
                    child: CameraPreview(lightController.repository.cameraController!),
                  ),
                );
              }
              return const LoadingDialog();
            },
          ),
        ),
        Center(
          child: ClipPath(
            clipper: HoleClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.4), // 设置遮罩层颜色
              ),
            ),
          ),
        ),
        _buildNav,
        _buildLightTips2,
        _buildLux(290, 166),
        _buildSuitableLight,
        _buildLightTips1,
      ],
    );
  }

  Widget get _buildAndroid {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('images/icon/light_bg.png', fit: BoxFit.cover)),
        Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.7))),
        _buildNav,
        _buildLightTips2,
        Positioned(
          top: mediaQueryTop + 155,
          left: 0,
          right: 0,
          child: Image.asset(
            'images/icon/light_center.png',
            width: 310,
            height: 310,
          ),
        ),
        _buildLux(),
        _buildSuitableLight,
        _buildLightTips1,
      ],
    );
  }

  Positioned get _buildLightTips1 {
    return Positioned(
      left: 0,
      right: 0,
      top: mediaQueryTop + 588,
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
    );
  }

  Widget _buildLux([double size = 310, int top = 155]) {
    return Positioned(
      top: mediaQueryTop + top,
      left: 0,
      right: 0,
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/icon/light_sun1.png',
              width: 80,
            ),
            const SizedBox(height: 24),
            Obx(() {
              return Text(
                '${lightController.repository.lux.value} LUX',
                style: const TextStyle(
                  color: UIColor.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget get _buildSuitableLight {
    return Positioned(
      top: mediaQueryTop + 510,
      left: 0,
      right: 0,
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            Color bgColor = const Color(0x66440606);
            Color borderColor = const Color(0xFFBA5656);
            Color textColor = UIColor.cFD5050;
            String text = 'insufficientLighting'.tr;
            String icon = 'images/icon/light_warning.png';
            if (lightController.repository.lux.value >= 500 && lightController.repository.lux.value <= 3000) {
              bgColor = const Color(0x66064432);
              borderColor = const Color(0xFF3B9E6F);
              textColor = UIColor.c40BD95;
              text = 'appropriateLighting'.tr;
              icon = 'images/icon/light_sun2.png';
            }
            return Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: ShapeDecoration(
                color: bgColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: borderColor,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget get _buildLightTips2 {
    return Positioned(
      top: mediaQueryTop + 86,
      left: 0,
      right: 0,
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/light_plant.png',
            width: 24,
          ),
          const SizedBox(width: 10),
          Text(
            'lightTips'.tr,
            style: TextStyle(
              color: UIColor.white,
              fontSize: 14,
              fontWeight: FontWeightExt.medium,
            ),
          ),
        ],
      ),
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
                onTap: () {
                  Get.bottomSheet(
                    BottomPopOptions(
                      hasBuoy: true,
                      hasClose: false,
                      children: [
                        Text(
                          'lightHelpTitle'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: UIColor.c15221D,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'lightHelpTips'.tr,
                          style: TextStyle(
                            color: UIColor.c8E8B8B,
                            fontSize: 14,
                            fontWeight: FontWeightExt.medium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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

class HoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const holeRadius = 145.0;
    final holeCenter = Offset(size.width / 2, Get.mediaQuery.padding.top + 166 + holeRadius);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // 覆盖整个区域
      ..addOval(Rect.fromCircle(center: holeCenter, radius: holeRadius)) // 创建镂空的圆形区域
      ..fillType = PathFillType.evenOdd; // 使用 evenOdd 以实现镂空效果
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
