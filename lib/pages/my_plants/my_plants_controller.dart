import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/widgets/custom_segmented.dart';

part 'my_plants_repository.dart';

class MyPlantsController extends GetxController {
  final MyPlantsRepository repository = MyPlantsRepository();

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

  void onSegmentChange(CustomSegmentedValue value) {
    if (value == repository.currentTab.value) {
      return;
    }
    repository.currentTab.value = value;
    // TODO 刷新
  }
}
