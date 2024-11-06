import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/pages/reminder_edit/reminder_edit_controller.dart';
import 'package:plant/widgets/show_dialog.dart';

class BottomsheetRemindMe {
  final ReminderEditController reminderEditCtr;

  BottomsheetRemindMe({required this.reminderEditCtr});
  void show() {
    Get.bottomSheet(
      BottomPopOptions(
        hasBuoy: true,
        hasClose: false,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, // 每行显示的项目数量
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: ((Get.width - 64) / 2) / 60,
          children: reminderEditCtr.repository.remindTypsList.map((remindType) {
            return GestureDetector(
              onTap: () {
                reminderEditCtr.didSelectRemindType(remindType);
                Get.back();
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      remindType['icon'],
                      width: 28,
                    ),
                    const SizedBox(width: 14),
                    Text(remindType['title']),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
