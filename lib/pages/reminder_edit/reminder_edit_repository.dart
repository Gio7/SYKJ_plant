part of 'reminder_edit_controller.dart';

class ReminderEditRepository {
  /// 0浇水 1加湿 2施肥 3转向
  final List<Map<String, dynamic>> remindTypsList = [
    {"type": 0, "title": "watering".tr, "icon": "images/icon/water.png"},
    {"type": 1, "title": "misting".tr, "icon": "images/icon/atomizing.png"},
    {"type": 2, "title": "fertilizing".tr, "icon": "images/icon/fertilizer.png"},
    {"type": 3, "title": "rotating".tr, "icon": "images/icon/rotate.png"},
  ];

  RxnString tempClock = RxnString();
  RxBool tempStatus = RxBool(false);
  RxString nextPlanTime = "".obs;

  String? plantName;
  String? scientificName;
  String? thumbnail;

  /// 植物ID
  late int recordId;

  /// 当前选择的类型
  RxMap<String, dynamic> currentRemindType = <String, dynamic>{}.obs;

  /// 周期值
  RxnInt cycle = RxnInt();

  /// 周期单位 day week month
  RxnString unit = RxnString();

  /// 推送时间 "10:33"
  RxnString clock = RxnString();

  /// 计划执行锚点时间 "2024-11-06"
  // RxnString previousTime = RxnString();
  RxnInt previousTimestamp = RxnInt();

  /// 推送开关
  RxBool status = RxBool(false);

  ReminderEditRepository() {
    final args = Get.arguments;
    if (args != null) {
      TimedPlan? timedPlanModel = args['timedPlanModel'];
      final PlantModel? plantModel = args['plantModel'];

      if (timedPlanModel != null) {
        plantName = timedPlanModel.plantName;
        scientificName = timedPlanModel.scientificName;
        thumbnail = timedPlanModel.thumbnail;

        if (timedPlanModel.clock != null) {
          tempClock.value = DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(timedPlanModel.clock!));
        }
        tempStatus.value = timedPlanModel.status;

        recordId = timedPlanModel.id!;
        currentRemindType.value = remindTypsList[timedPlanModel.type!];

        cycle.value = timedPlanModel.cycle;
        unit.value = timedPlanModel.unit;
        clock.value = tempClock.value;
        previousTimestamp.value = timedPlanModel.previousTimestamp;
        status.value = timedPlanModel.status;
      } else if (plantModel != null) {
        plantName = plantModel.plantName;
        scientificName = plantModel.scientificName;
        thumbnail = plantModel.thumbnail;

        recordId = plantModel.id!;

        final type = args['type'];
        if (type != null && type is int) {
          timedPlanModel = plantModel.timedPlans!.firstWhereOrNull((e) => e.type == type);
        } else if (plantModel.timedPlans != null && plantModel.timedPlans!.isNotEmpty) {
          timedPlanModel = plantModel.timedPlans!.reduce((a, b) => a.updateTime.isAfter(b.updateTime) ? a : b);
        }
        if (timedPlanModel != null) {
          if (timedPlanModel.clock != null) {
            tempClock.value = DateFormat("HH:mm").format(DateFormat("HH:mm:ss").parse(timedPlanModel.clock!));
          }

          tempStatus.value = timedPlanModel.status;

          currentRemindType.value = remindTypsList[timedPlanModel.type!];

          cycle.value = timedPlanModel.cycle;
          unit.value = timedPlanModel.unit;
          clock.value = tempClock.value;
          previousTimestamp.value = timedPlanModel.previousTimestamp;
          status.value = timedPlanModel.status;
        }
      }
    }
  }
}
