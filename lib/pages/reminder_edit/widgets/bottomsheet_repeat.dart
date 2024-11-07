import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/reminder_edit/reminder_edit_controller.dart';

class BottomsheetRepeat {
  final ReminderEditController reminderEditCtr;

  BottomsheetRepeat({required this.reminderEditCtr});
  void show() {
    List<PickerItem<String>> dayData = List.generate(
      31,
      (i) => PickerItem(value: "${i + 1}"),
    );

    List<PickerItem<String>> weekData = List.generate(
      52,
      (i) => PickerItem(value: "${i + 1}"),
    );

    List<PickerItem<String>> monthData = List.generate(
      12,
      (i) => PickerItem(value: "${i + 1}"),
    );
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
    List<PickerItem<String>> typeData = [
      PickerItem(value: 'days'.tr, children: dayData),
      PickerItem(value: 'weeks'.tr, children: weekData),
      PickerItem(value: 'months'.tr, children: monthData),
    ];
    Picker(
        height: 250,
        adapter: PickerDataAdapter<String>(
          data: typeData,
        ),
        // selecteds: ,
        changeToFirst: true, // 切换选项后刷新下一级选项
        hideHeader: false,
        reversedOrder: true,
        itemExtent: 48,
        textAlign: TextAlign.center,
        textStyle: itemStyle.copyWith(color: UIColor.cBBBDBF),
        selectedTextStyle: itemStyle,
        backgroundColor: UIColor.cF3F4F3,
        // containerColor: ,
        // headerDecoration: const BoxDecoration(
        //   color: UIColor.cF3F4F3,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(30),
        //     topRight: Radius.circular(30),
        //   ),
        // ),
        // confirmText: 'confirm'.tr,
        // cancelText: 'cancel'.tr,
        // confirmTextStyle: headerTextStyle,
        // cancelTextStyle: headerTextStyle.copyWith(color: UIColor.c8E8B8B),
        // title: Text(
        //   'repeat'.tr,
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(
        //     color: UIColor.c15221D,
        //     fontSize: 18,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // onConfirm: (Picker picker, List<int> selectedIndexes) {

        // },
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
                      onPressed: () => Get.back(),
                      child: Text(
                        'cancel'.tr,
                        style: headerTextStyle.copyWith(color: UIColor.c8E8B8B),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final picker = PickerWidget.of(context).data;
                        final selectedType = picker.getSelectedValues()[0];
                        final selectedValue = picker.getSelectedValues()[1];
                        // print(picker.selecteds[0]);
                        // print("选择的类型: $selectedType");
                        // print("选择的值: $selectedValue");
                        final unit = selectedType == 'days'.tr ? 'day' : selectedType == 'weeks'.tr ? 'week' : 'month';
                        reminderEditCtr.setCycle(unit,int.tryParse(selectedValue));
                        Get.back();
                      },
                      child: Text(
                        'confirm'.tr,
                        style: headerTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },onSelect: (picker, index, selected) {
          
        },).showModal(Get.context!);
  }
}
