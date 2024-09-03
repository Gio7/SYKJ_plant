import 'package:get/get.dart';
import 'package:plant/models/plant_model.dart';

class MyPlantsRepository {
  RxList<PlantModel> dataList = <PlantModel>[].obs;
  int pageNum = 1;
  RxBool isLoading = false.obs;
  bool isLastPage = false;

  MyPlantsRepository() {
    // 初始化数据
  }
}
