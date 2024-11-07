import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/pages/identify_history/identify_history_page.dart';
import 'package:plant/pages/plant_scan/shoot_page.dart';
import 'package:plant/pages/reminder_edit/reminder_edit_page.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/widgets/show_dialog.dart';

import 'my_plants_controller.dart';
import 'widgets/plant_empty_widget.dart';
import 'widgets/plant_item_reminder.dart';

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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: NormalButton(
                text: 'snapHistory'.tr,
                bgColor: UIColor.transparentPrimary40,
                textColor: UIColor.c00997A,
                iconWidget: Image.asset('images/icon/camera_histroy.png', width: 24),
                borderRadius: 12,
                onTap: () {
                  Get.to(() => const IdentifyHistoryPage());
                },
              ),
            ),
            Expanded(
              child: EasyRefresh(
                onRefresh: () {
                  controller.onPlantRefresh();
                },
                onLoad: () {
                  controller.onPlantLoad();
                },
                child: GroupedListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  groupBy: (element) => element.createTimeLocal,
                  order: GroupedListOrder.DESC,
                  groupSeparatorBuilder: (String value) => Container(
                    height: 20.0,
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('images/icon/time.png', width: 20),
                        const SizedBox(width: 8),
                        Text(
                          value,
                          style: TextStyle(
                            color: UIColor.c85B9A8,
                            fontSize: 12,
                            fontWeight: FontWeightExt.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  groupItemBuilder: (_, model, __, groupEnd) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: groupEnd ? 16 : 0),
                      child: PlantItemReminder(
                        model: model,
                        onTap: () => controller.getPlantDetailByRecord(model),
                        onMore: () => _onMore(model),
                        onSetReminder: (int? type) => _onSetReminder(type, model),
                      ),
                    );
                  },
                  separator: const SizedBox(height: 10),
                  elements: repository.plantDataList,
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
              onTap: () {
                Get.back();
                _onSetReminder(null, model);
              },
              text: 'setReminder'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/alarmClock3.png', width: 28),
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
              textColor: UIColor.cFD5050,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/delete_red.png', width: 28),
            ),
          ),
        ],
      ),
    );
  }

  void _onSetReminder(int? type, PlantModel model) {
    Get.to(
      () => ReminderEditPage(),
      arguments: {'type': type, "plantModel": model},
    );
  }
}
