import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/pages/plant_scan/info_identify_page.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/loading_dialog.dart';

part 'identify_history_repository.dart';

class IdentifyHistoryController extends GetxController {
  IdentifyHistoryRepository repository = IdentifyHistoryRepository();

  @override
  void onInit() {
    super.onInit();
    repository.isLoading.value = true;
    onRefresh();
  }

  Future<void> onRefresh() async {
    repository.isLastPage = false;
    repository.pageNum = 1;
    final res = await Request.getPlantScanHistory(repository.pageNum, type: "all");
    repository.isLastPage = res['lastPage'];
    repository.total = res['total'] ?? 0;
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.isLoading.value = false;
    repository.dataList.value = rows;
  }

  Future<void> onLoad() async {
    if (repository.isLastPage) return;
    repository.pageNum++;
    final res = await Request.getPlantScanHistory(repository.pageNum, type: "all");
    repository.isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.dataList.addAll(rows);
  }

  Future<void> onDetailById(PlantModel model) async {
    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    try {
      final res = await Request.getPlantDetailByRecord(model.id!);
      Get.back();
      
      final p = PlantInfoModel.fromJson(res);
      final ctr = Get.put(PlantController(ShootType.identify, hasCamera: false));
      ctr.repository.plantInfo = p;

      await Get.to(() => InfoIdentifyPage(hideBottom: true));
      Get.delete<PlantController>();
    } catch (e) {
      Get.back();
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
