import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/my_plants/plants_chose_page.dart';
import 'package:plant/pages/reminder_edit/reminder_edit_page.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';

import 'my_plants_controller.dart';
import 'widgets/plant_empty_widget.dart';
import 'widgets/reminder_item.dart';

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
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (_, i) {
                    final reminderModel = repository.reminderDataList[i];
                    return Column(
                      children: [
                        Container(
                          height: 20.0,
                          margin: const EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Image.asset('images/icon/time.png', width: 20),
                              const SizedBox(width: 8),
                              Text(
                                reminderModel.date,
                                style: TextStyle(
                                  color: UIColor.c85B9A8,
                                  fontSize: 12,
                                  fontWeight: FontWeightExt.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 6),
                          itemBuilder: (_, j) {
                            final recordModel = reminderModel.records[j];
                            return ReminderItem(
                                model: recordModel,
                                onTap: () {
                                  recordModel.isExpanded = !recordModel.isExpanded;
                                  reminderModel.records[j] = recordModel;
                                  repository.reminderDataList[i] = reminderModel;
                                },
                                onPlant: (timedPlan) {
                                  Get.to(
                                    () => ReminderEditPage(),
                                    arguments: {"timedPlanModel": timedPlan},
                                  );
                                });
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemCount: reminderModel.records.length,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemCount: repository.reminderDataList.length,
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
