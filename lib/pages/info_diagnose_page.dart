import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/loading_dialog.dart';
import 'package:plant/controllers/plant_controller.dart';
import 'package:plant/pages/info_identify_page.dart';

class InfoDiagnosePage extends StatelessWidget {
  InfoDiagnosePage({super.key});

  final ctr = Get.find<PlantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.cF3F4F3,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 290,
            child: CachedNetworkImage(
              imageUrl: ctr.thumbnailUrl ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: SingleChildScrollView(
              // physics: const ClampingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(top: 256, bottom: 70 + Get.mediaQuery.padding.bottom),
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                decoration: const ShapeDecoration(
                  color: UIColor.cF3F4F3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            top: 60,
                            left: 20,
                            right: 20,
                            bottom: 24,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'yourPlantIs'.tr,
                                      style: const TextStyle(
                                        color: UIColor.c15221D,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${ctr.diagnoseInfo['healthy'] ? 'notHealthy'.tr : 'healthy'.tr}',
                                      style: TextStyle(
                                        color: ctr.diagnoseInfo['healthy'] ? UIColor.primary : UIColor.cFD5050,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'diagnosisTips'.tr,
                                style: TextStyle(
                                  color: UIColor.c8E8B8B,
                                  fontSize: 12,
                                  fontWeight: FontWeightExt.medium,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: -45,
                          height: 90,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset('images/icon/detail_head.png'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      ctr.diagnoseInfo['scientificName'],
                      style: const TextStyle(
                        color: UIColor.c15221D,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ctr.diagnoseInfo['treatmentPlan'],
                      style: const TextStyle(
                        color: UIColor.c15221D,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 64 + Get.mediaQuery.padding.bottom,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10 + Get.mediaQuery.padding.bottom),
              color: UIColor.white,
              child: Row(
                children: [
                  Expanded(
                    child: NormalButton(
                      onTap: () async{
                        Get.dialog(const LoadingDialog(), barrierDismissible: false);
                        await ctr.scanByScientificName(ctr.diagnoseInfo['scientificName']);
                        Get.back();
                        Get.to(() => const InfoIdentifyPage());
                      },
                      icon: 'images/icon/detail_conditions.png',
                      text: 'plantInfo'.tr,
                      textColor: UIColor.white,
                      bgColor: UIColor.c40BD95,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NormalButton(
                      onTap: () => Get.back(),
                      icon: 'images/icon/detail_camera.png',
                      text: 'retake'.tr,
                      textColor: UIColor.white,
                      bgColor: UIColor.cF6A469,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 0,
            right: 0,
            height: 56 + Get.mediaQuery.padding.top,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  'images/icon/detail_arrow_right.png',
                  width: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
