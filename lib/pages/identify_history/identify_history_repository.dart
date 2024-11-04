part of 'identify_history_controller.dart';
class IdentifyHistoryRepository {
  RxList<PlantModel> dataList = <PlantModel>[].obs;
  int pageNum = 1;
  RxBool isLoading = false.obs;
  bool isLastPage = false;
}