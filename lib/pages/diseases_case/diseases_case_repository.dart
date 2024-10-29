part of 'diseases_case_controller.dart';

class DiseasesCaseRepository {
  RxList<PlantModel> dataList = <PlantModel>[].obs;
  int pageNum = 1;
  RxBool isLoading = false.obs;
  bool isLastPage = false;

  DiseasesCaseRepository() {
    // 初始化数据
  }
}
