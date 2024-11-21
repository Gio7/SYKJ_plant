import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/models/plant_diagnosis_model.dart';
import 'package:plant/pages/plant_scan/info_diagnose_page.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/loading_dialog.dart';

import 'diagnose_history_model.dart';

part 'diagnose_history_repository.dart';

class DiagnoseHistoryController extends GetxController {
  DiagnoseHistoryRepository repository = DiagnoseHistoryRepository();

  @override
  void onInit() {
    super.onInit();
    repository.isLoading.value = true;
    onRefresh();
  }

  Future<void> onRefresh() async {
    repository.isLastPage = false;
    repository.pageNum = 1;
    final res = await Request.diagnosisHistory(repository.pageNum);
    repository.isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((x) => DiagnosisHistoryModel.fromJson(x)).toList();
    repository.isLoading.value = false;
    repository.dataList.value = rows;
  }

  Future<void> onLoad() async {
    if (repository.isLastPage) return;
    repository.pageNum++;
    final res = await Request.diagnosisHistory(repository.pageNum);
    repository.isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((x) => DiagnosisHistoryModel.fromJson(x)).toList();
    repository.dataList.addAll(rows);
  }

  Future<void> onDetailById(int? id) async {
    if (id == null) return;
    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    try {
      final res = await Request.diagnosisHistoryDetailById(id);
      Get.back();
      final p = PlantDiagnosisModel.fromJson(res);
      final ctr = Get.put(PlantController(ShootType.diagnose, hasCamera: false));
      ctr.repository.diagnoseInfo = p;

      await Get.to(() => InfoDiagnosePage(hideBottom: true));
      Get.delete<PlantController>();
    } catch (e) {
      Get.back();
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
