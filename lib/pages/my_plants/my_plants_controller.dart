import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/pages/plant_scan/info_identify_page.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/custom_segmented.dart';
import 'package:plant/widgets/loading_dialog.dart';

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

  void onSegmentChange(CustomSegmentedValue value) {
    if (value == repository.currentTab.value) {
      return;
    }
    repository.currentTab.value = value;
    if (!Get.find<UserController>().isLogin.value) {
      return;
    }
    if (value.value == '1') {
      if (repository.plantDataList.isEmpty) {
        repository.plantIsLoading.value = true;
        onPlantRefresh();
      }
    } else {
      if (repository.reminderDataList.isEmpty) {
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
  }

  // MARK: - 提醒相关逻辑

  Future<void> onReminderRefresh() async {
    repository.reminderIsLoading.value = true;
    // TODO 更换接口
    repository.reminderIsLastPage = false;
    repository.reminderPageNum = 1;
    final res = await Request.getPlantScanHistory(repository.reminderPageNum);
    repository.reminderIsLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.reminderIsLoading.value = false;
    // repository.reminderDataList.value = rows;
    repository.reminderIsLastPage = true;
  }

  Future<void> onReminderLoad() async {
    // TODO 更换接口
    if (repository.reminderIsLastPage) return;
    repository.reminderPageNum++;
    final res = await Request.getPlantScanHistory(repository.reminderPageNum);
    repository.reminderIsLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    // repository.reminderDataList.addAll(rows);
  }
}
