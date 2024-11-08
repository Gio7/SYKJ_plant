import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/date_util.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/models/reminder_model.dart';
import 'package:plant/pages/my_plants/my_plants_controller.dart';
import 'package:plant/widgets/loading_dialog.dart';

part 'reminder_edit_repository.dart';

class ReminderEditController extends GetxController {
  final ReminderEditRepository repository = ReminderEditRepository();

  @override
  void onInit() {
    super.onInit();
    nextTimedPlan();
  }

  void didSelectRemindType(Map<String, dynamic> remindType) {
    repository.currentRemindType.value = remindType;
  }

  void setClock(String? clock) {
    repository.clock.value = clock;
    repository.status.value = repository.tempStatus.value;
    nextTimedPlan();
  }

  void setPreviousTimestamp(DateTime? time) {
    repository.previousTimestamp.value = time?.millisecondsSinceEpoch;
    nextTimedPlan();
  }

  void setCycle(String unit, int? cycle) {
    repository.cycle.value = cycle;
    repository.unit.value = unit;
    nextTimedPlan();
  }

  void nextTimedPlan() {
    if (repository.previousTimestamp.value == null ||
        repository.currentRemindType.isEmpty ||
        repository.unit.value == null ||
        repository.cycle.value == null ||
        repository.clock.value == null) {
      repository.nextPlanTime.value = '';
      return;
    }
    final unit = repository.unit.value!;
    final cycle = repository.cycle.value!;

    DateTime previousDate = DateTime.fromMillisecondsSinceEpoch(repository.previousTimestamp.value!).toLocal();
    DateTime currentDate = DateTime.now();

    // 计算下一个周期时间
    DateTime nextCycleDate = previousDate;

    while (nextCycleDate.isBefore(currentDate) || nextCycleDate.isAtSameMomentAs(currentDate)) {
      switch (unit) {
        case "day":
          nextCycleDate = nextCycleDate.add(Duration(days: cycle));
          break;
        case "week":
          nextCycleDate = nextCycleDate.add(Duration(days: 7 * cycle));
          break;
        case "month":
          nextCycleDate = DateTime(nextCycleDate.year, nextCycleDate.month + cycle, nextCycleDate.day);
          break;
        default:
          throw Exception("Unsupported unit: $unit");
      }
    }

    repository.nextPlanTime.value = DateFormat.yMd().format(nextCycleDate);
  }

  Future<void> plantAlarmUpdate() async {
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      await Request.plantAlarmUpdate(
        recordId: repository.recordId,
        type: repository.currentRemindType['type'],
        cycle: repository.cycle.value!,
        unit: repository.unit.value!,
        clock: repository.clock.value!,
        previous: getPreviousTime(repository.previousTimestamp.value!),
        status: repository.status.value,
      );
      final ctr = Get.find<MyPlantsController>();
      await ctr.onReminderRefresh();
      await ctr.onPlantRefresh();
      Get.back(closeOverlays: true);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      rethrow;
    }
  }

  String getPreviousTime(int previousTimestamp) {
    return DateUtil.formatMilliseconds(previousTimestamp, format: DateFormat("yyyy-MM-dd"));
  }
}
