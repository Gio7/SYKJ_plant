import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/common_util.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/pages/my_plants/my_plants_controller.dart';

import 'widgets/important_information.dart';
import 'widgets/info_characteristics.dart';
import 'widgets/info_key_facts.dart';
import 'widgets/info_description_text.dart';
import 'widgets/info_fun_facts.dart';
import 'widgets/plant_crare_requirements.dart';

class InfoIdentifyPage extends StatelessWidget {
  InfoIdentifyPage({super.key, this.hideBottom = false});

  final bool hideBottom;
  final ctr = Get.find<PlantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.cF3F4F3,
      body: Stack(
        children: [
          _buildHeadImage(),
          _buildBody(),
          if (!hideBottom) _buildBottomBtn(),
          _buildNav(),
        ],
      ),
    );
  }

  Positioned _buildHeadImage() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      height: 290,
      child: CachedNetworkImage(
        imageUrl: ctr.repository.plantInfo?.plant?.thumbnail ?? '',
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
      ),
    );
  }

  Positioned _buildBody() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 226, bottom: 70 + Get.mediaQuery.padding.bottom),
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
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
              ..._buildTitle(),
              const SizedBox(height: 24),
              ImportantInformation(scientificClassification: ctr.repository.plantInfo?.plant?.scientificClassification),
              const SizedBox(height: 16),
              InfoCharacteristics(characteristics: ctr.repository.plantInfo?.plant?.characteristics),
              const SizedBox(height: 16),
              InfoDescriptionText(text: ctr.repository.plantInfo?.plant?.culturalSignificance ?? ''),
              const SizedBox(height: 16),
              InfoKeyFacts(descriptionList: ctr.repository.plantInfo?.plant?.description),
              const SizedBox(height: 16),
              PlantCrareRequirements(
                conditions: ctr.repository.plantInfo?.plant?.conditions,
                howTos: ctr.repository.plantInfo?.plant?.howTos,
              ),
              const SizedBox(height: 16),
              if (ctr.repository.plantInfo?.plant?.littleStory != null &&
                  ctr.repository.plantInfo?.plant?.littleStory != '')
                InfoFunFacts(littleStory: ctr.repository.plantInfo!.plant!.littleStory!),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _buildNav() {
    return Positioned(
      left: 10,
      top: 0,
      right: 0,
      height: 56 + Get.mediaQuery.padding.top,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              'images/icon/detail_arrow_right.png',
              width: 32,
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildBottomBtn() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 64 + Get.mediaQuery.padding.bottom,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10 + Get.mediaQuery.padding.bottom),
        color: UIColor.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                FireBaseUtil.logEvent(EventName.infoShoot);
                Get.until((route) => Get.currentRoute == '/ShootPage');
              },
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: UIColor.transparentPrimary40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(256),
                  ),
                ),
                child: const ImageIcon(
                  AssetImage('images/icon/detail_camera.png'),
                  color: UIColor.primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NormalButton(
                onTap: Common.debounce(() async {
                  if (ctr.repository.plantInfo?.scanRecordId == null) {
                    return;
                  }
                  FireBaseUtil.logEvent(EventName.infoSave);
                  Get.dialog(const LoadingDialog());
                  await ctr.savePlant(ctr.repository.plantInfo!.scanRecordId!);
                  Get.back();
                  if (Get.find<MainController>().tabController.index != 4) {
                    Get.find<MainController>().tabController.index = 4;
                  }
                  if (Get.isRegistered<MyPlantsController>()) {
                    final c = Get.find<MyPlantsController>();
                    c.onSegmentChange(c.repository.customSegmentedValues[0]);
                    if (!c.repository.plantIsLoading.value) {
                      c.onPlantRefresh();
                    }
                  }
                  Get.until((route) => Get.currentRoute == '/');
                }, 500),
                text: 'saveToMyGarden'.tr,
                textColor: UIColor.white,
                bgColor: UIColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTitle() {
    final mainCharacteristics = ctr.repository.plantInfo?.plant?.mainCharacteristics ?? '';
    return [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          ctr.repository.plantInfo?.plant?.plantName ?? '',
          style: const TextStyle(
            color: UIColor.c15221D,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${'scientificName'.tr} ',
                style: const TextStyle(
                  color: UIColor.c00997A,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ctr.repository.plantInfo?.plant?.scientificName ?? '',
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      if (mainCharacteristics.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 4),
          child: Text(
            mainCharacteristics,
            style: TextStyle(
              color: UIColor.c15221D,
              fontSize: 14,
              fontWeight: FontWeightExt.medium,
            ),
          ),
        ),
    ];
  }
}
