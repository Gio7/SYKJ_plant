import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/models/plant_model.dart';

part 'diseases_case_repository.dart';

class DiseasesCaseController extends GetxController {
  final DiseasesCaseRepository repository = DiseasesCaseRepository();

  @override
  void onInit() {
    super.onInit();
    repository.isLoading.value = true;
    onRefresh();
  }

  Future<void> onRefresh() async {
    repository.isLastPage = false;
    repository.pageNum = 1;
    final res = await Request.getPlantScanHistory(repository.pageNum);
    repository.isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.isLoading.value = false;
    repository.dataList.value = rows;
  }

  Future<void> onLoad() async {
    if (repository.isLastPage) return;
    repository.pageNum++;
    final res = await Request.getPlantScanHistory(repository.pageNum);
    repository.isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    repository.dataList.addAll(rows);
  }
}
