import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/pages/plant_scan/shoot_page.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/widgets/show_dialog.dart';

import 'my_plants_controller.dart';
import 'widgets/plant_empty_widget.dart';

class PlantsPage extends StatelessWidget {
  PlantsPage({super.key});
  final controller = Get.find<MyPlantsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final repository = Get.find<MyPlantsController>().repository;
      if (repository.plantDataList.isEmpty) {
        if (repository.plantIsLoading.value) return const LoadingDialog();
        return _empty;
      }
      return Expanded(
        child: Column(
          children: [
            // NormalButton(text: text, textColor: textColor, bgColor: bgColor),
            Expanded(
              child: EasyRefresh(
                onRefresh: () {
                  controller.onRefresh();
                },
                onLoad: () {
                  controller.onLoad();
                },
                child: Obx(
                  () => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    itemBuilder: (_, i) {
                      final p = repository.plantDataList[i];
                      return _buildItem(p);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemCount: repository.plantDataList.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget get _empty {
    return PlantEmptyWidget(
      text: 'youHaveNoPlants'.tr,
      iconImage: 'images/icon/plants.png',
      btnText: 'addPlant'.tr,
      onBtnTap: () {
        Get.to(() => const ShootPage());
      },
    );
  }

  Widget _buildItem(PlantModel model) {
    return GestureDetector(
      onTap: () => controller.getPlantDetailByRecord(model),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: ShapeDecoration(
          color: UIColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: model.thumbnail ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.plantName ?? '',
                    style: const TextStyle(
                      color: UIColor.c15221D,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${'addedAt'.tr} ${model.createTimeLocal}',
                    style: TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 12,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _onMore(model);
              },
              child: Image.asset(
                'images/icon/more.png',
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMore(PlantModel model) {
    Get.bottomSheet(
      BottomPopOptions(
        children: [
          SizedBox(
            width: double.infinity,
            child: NormalButton(
              onTap: () {
                FireBaseUtil.logEvent(EventName.listRename);
                Get.back();
                Get.dialog(
                  TextFieldDialog(
                    title: 'setYourPlantName'.tr,
                    confirmText: 'save'.tr,
                    cancelText: 'cancel'.tr,
                    value: model.plantName,
                    onConfirm: (String v) async {
                      Get.back();
                      controller.plantScanRename(model.id!, v);
                    },
                  ),
                );
              },
              text: 'rename'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/edit.png', width: 28),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: NormalButton(
              onTap: () async {
                FireBaseUtil.logEvent(EventName.listRemove);
                Get.back();
                Get.dialog(
                  NormalDialog(
                    title: 'warning'.tr,
                    confirmText: 'delete'.tr,
                    cancelText: 'cancel'.tr,
                    subText: 'deletePlantTips'.tr,
                    icon: Image.asset('images/icon/delete.png', height: 70),
                    confirmPositionLeft: false,
                    onConfirm: () async {
                      FireBaseUtil.logEvent(EventName.listRemoveAgree);
                      Get.back();
                      controller.plantScanDelete(model.id!);
                    },
                  ),
                );
              },
              text: 'removeBtn'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/delete_red.png', width: 28),
            ),
          ),
        ],
      ),
    );
  }
}
