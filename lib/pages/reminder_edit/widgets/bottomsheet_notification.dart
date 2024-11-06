
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/reminder_edit/reminder_edit_controller.dart';

class BottomsheetNotification {
  final ReminderEditController reminderEditCtr;

  BottomsheetNotification({required this.reminderEditCtr});

  void show() {
    final itemStyle = TextStyle(
      color: UIColor.black,
      fontSize: 16,
      fontWeight: FontWeightExt.medium,
    );
    const headerTextStyle = TextStyle(
      color: UIColor.c40BD95,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    Picker(
      height: 250,
      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM),
      // TODO 默认选项
      // selecteds: ,
      changeToFirst: false, // 切换选项后刷新下一级选项
      hideHeader: false,
      itemExtent: 48,
      textAlign: TextAlign.center,
      textStyle: itemStyle.copyWith(color: UIColor.cBBBDBF),
      selectedTextStyle: itemStyle,
      backgroundColor: UIColor.cF3F4F3,
      // containerColor: ,
      builderHeader: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: UIColor.cF3F4F3,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      reminderEditCtr.repository.tempClock.value = '';
                      Get.back();
                    },
                    child: Text(
                      'cancel'.tr,
                      style: headerTextStyle.copyWith(color: UIColor.c8E8B8B),
                    ),
                  ),
                  // Text(
                  //   'careNotification'.tr,
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     color: UIColor.c15221D,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {
                      // TODO 选择时间
                      final picker = PickerWidget.of(context);
                      print(picker.data.adapter.text);
                      print(picker.data.selecteds);
                      // print(isSwitchOn);
                      Get.back();
                    },
                    child: Text(
                      'confirm'.tr,
                      style: headerTextStyle,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/icon/alarmClock2.png',
                        width: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'noticeTime'.tr,
                        style: const TextStyle(
                          color: UIColor.c15221D,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        reminderEditCtr.repository.tempClock.value ?? '',
                        style: const TextStyle(
                          color: UIColor.c40BD95,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      FlutterSwitch(
                        width: 38,
                        height: 18,
                        toggleSize: 14,
                        padding: 2.0,
                        value: reminderEditCtr.repository.tempStatus.value,
                        onToggle: (v) {
                          reminderEditCtr.repository.tempStatus.value = v;
                        },
                        inactiveColor: UIColor.cE0E0E0,
                        activeColor: UIColor.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onSelect: (picker, index, selected) {
        // reminderEditCtr.repository.currentNotificationTime.value,
        reminderEditCtr.repository.tempClock.value = picker.adapter.text;
      },
    ).showModal(Get.context!);
  }
}