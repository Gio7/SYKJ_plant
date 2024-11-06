part of 'reminder_edit_controller.dart';

class ReminderEditRepository {
  final List<Map<String, dynamic>> remindTypsList = [
    {"type": "watering", "title": "watering".tr, "icon": "images/icon/water.png"},
    {"type": "misting", "title": "misting".tr, "icon": "images/icon/atomizing.png"},
    {"type": "fertilizing", "title": "fertilizing".tr, "icon": "images/icon/fertilizer.png"},
    {"type": "rotating", "title": "rotating".tr, "icon": "images/icon/rotate.png"},
  ];

  RxMap<String, dynamic> currentRemindType = <String, dynamic>{}.obs;

  RxString currentNotificationTime = ''.obs;
  RxBool isNotificationOn = false.obs;
}
