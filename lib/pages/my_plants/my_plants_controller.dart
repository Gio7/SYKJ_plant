import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/models/reminder_model.dart';
import 'package:plant/pages/plant_scan/info_identify_page.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/custom_segmented.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/widgets/show_dialog.dart';

part 'my_plants_repository.dart';

class MyPlantsController extends GetxController {
  final MyPlantsRepository repository = MyPlantsRepository();

  @override
  void onInit() {
    super.onInit();
    if (Get.find<UserController>().isLogin.value) {
      repository.plantIsLoading.value = true;
      onPlantRefresh();
    }
  }

  void onSegmentChange(CustomSegmentedValue value, {bool forceRefresh = false}) {
    repository.currentTab.value = value;
    if (!Get.find<UserController>().isLogin.value) {
      return;
    }
    if (value == repository.currentTab.value && !forceRefresh) {
      return;
    }
    if (value.value == '1') {
      if (repository.plantDataList.isEmpty && !forceRefresh) {
        repository.plantIsLoading.value = true;
        onPlantRefresh();
      }
    } else {
      if (repository.reminderDataList.isEmpty && !forceRefresh) {
        repository.reminderIsLoading.value = true;
        onReminderRefresh();
      }
    }
  }

  Future<void> onPlantRefresh() async {
    repository.plantIsLastPage = false;
    repository.plantPageNum = 1;
    final res = await Request.getPlantScanHistory(repository.plantPageNum);
    repository.plantIsLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.plantIsLoading.value = false;
    repository.plantDataList.value = rows;
  }

  Future<void> onPlantLoad() async {
    if (repository.plantIsLastPage) return;
    repository.plantPageNum++;
    final res = await Request.getPlantScanHistory(repository.plantPageNum);
    repository.plantIsLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.plantDataList.addAll(rows);
  }

  Future<void> getPlantDetailByRecord(PlantModel model) async {
    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    try {
      final res = await Request.getPlantDetailByRecord(model.id!);
      final p = PlantInfoModel.fromJson(res);
      final ctr = Get.put(PlantController(ShootType.identify, hasCamera: false));
      ctr.repository.plantInfo = p;
      Get.back();

      await Get.to(() => InfoIdentifyPage(hideBottom: true));
      ctr.dispose();
    } catch (e) {
      Get.back();
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> plantScanRename(int id, String plantName) async {
    Request.plantScanRename(id, plantName);
    final index = repository.plantDataList.indexWhere((element) => id == element.id);
    if (index >= 0) {
      repository.plantDataList[index].plantName = plantName;
      repository.plantDataList[index] = repository.plantDataList[index];
    }
  }

  Future<void> plantScanDelete(int id) async {
    Request.plantScanDelete(id);
    repository.plantDataList.removeWhere((element) => element.id == id);
    if (repository.reminderDataList.isNotEmpty) {
      onReminderRefresh();
    }
  }

  // MARK: - 提醒相关逻辑

  Future<void> onReminderRefresh() async {
    repository.reminderIsLoading.value = true;
    repository.reminderIsLastPage = false;
    repository.reminderPageNum = 1;
    final res = await Request.getReminders(repository.reminderPageNum);
    repository.reminderIsLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => ReminderModel.fromJson(plant)).toList();
    repository.reminderIsLoading.value = false;
    repository.reminderDataList.value = rows;
    repository.reminderIsLastPage = true;
    // repository.reminderDataList.value = List<ReminderModel>.generate(8, (int index) {
    //   return ReminderModel(records: [
    //     Record(type: 1, items: [Item()]),
    //     Record(type: 2, items: [Item(),Item()]),
    //     Record(type: 3, items: [Item(),Item(),Item()]),
    //   ], date: '2022-09-2$index');
    // });
  }

  Future<void> onReminderLoad() async {
    if (repository.reminderIsLastPage) return;
    repository.reminderPageNum++;
    final res = await Request.getReminders(repository.reminderPageNum);
    repository.reminderIsLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => ReminderModel.fromJson(plant)).toList();
    repository.reminderDataList.addAll(rows);
  }

  Future<void> plantAlarmDelete(int? recordId, int? type,{required int index, required int index2}) async {
    if (recordId == null || type == null) return;
    Get.dialog(
      NormalDialog(
        title: 'warning'.tr,
        confirmText: 'delete'.tr,
        cancelText: 'cancel'.tr,
        subText: 'deletePlanTips'.tr,
        icon: Image.asset('images/icon/delete.png', height: 70),
        confirmPositionLeft: false,
        onConfirm: () async {
          Get.back();
          try {
            Get.dialog(const LoadingDialog(), barrierDismissible: false);
            await Request.plantAlarmDelete(recordId, type);
            Get.back();
            repository.reminderDataList[index].records[index2].items.removeWhere((item) => item.id == recordId);
            repository.reminderDataList[index] = repository.reminderDataList[index];
            final plantListIndex = repository.plantDataList.indexWhere((element) => element.id == recordId);
            if (plantListIndex >= 0) {
              repository.plantDataList[plantListIndex].timedPlans?.removeWhere((item) => item.type == type);
              repository.plantDataList[plantListIndex] = repository.plantDataList[plantListIndex];
            }
          } catch (e) {
            Get.back();
            Get.log(e.toString(), isError: true);
            rethrow;
          }
        },
      ),
    );
  }
}
