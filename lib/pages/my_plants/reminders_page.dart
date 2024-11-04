import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/my_plants/plants_chose_page.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';

import 'my_plants_controller.dart';
import 'widgets/plant_empty_widget.dart';
import 'widgets/plant_item_reminder.dart';

class RemindersPage extends StatelessWidget {
  RemindersPage({super.key});
  final controller = Get.find<MyPlantsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final repository = Get.find<MyPlantsController>().repository;
      if (repository.reminderDataList.isEmpty) {
        if (repository.reminderIsLoading.value) return const LoadingDialog();
        return _empty;
      }
      return Expanded(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: NormalButton(
                text: 'addReminder'.tr,
                bgColor: UIColor.transparentPrimary40,
                textColor: UIColor.c00997A,
                iconWidget: Image.asset('images/icon/alarmClock.png', width: 24),
                borderRadius: 12,
                onTap: () {
                  _onAddTap();
                },
              ),
            ),
            Expanded(
              child: EasyRefresh(
                onRefresh: () {
                  controller.onReminderRefresh();
                },
                onLoad: () {
                  controller.onReminderLoad();
                },
                child: Obx(
                  () => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    itemBuilder: (_, i) {
                      final p = repository.reminderDataList[i];
                      // TODO 更换视图
                      return PlantItemReminder(
                        model: p,
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemCount: repository.reminderDataList.length,
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
      text: 'youHaveNoReminders'.tr,
      iconImage: 'images/icon/reminders2.png',
      btnText: 'addReminder'.tr,
      onBtnTap: () {
        _onAddTap();
      },
    );
  }

  void _onAddTap() {
    Get.to(() => const PlantsChosePage());
  }
}
