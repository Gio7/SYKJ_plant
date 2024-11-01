part of 'my_plants_controller.dart';

class MyPlantsRepository {
  RxList<PlantModel> dataList = <PlantModel>[].obs;
  int pageNum = 1;
  RxBool isLoading = false.obs;
  bool isLastPage = false;
  final List<CustomSegmentedValue> customSegmentedValues = [CustomSegmentedValue('allPlants'.tr, '1'), CustomSegmentedValue('reminders'.tr, '2')];

  late Rx<CustomSegmentedValue> currentTab;

  MyPlantsRepository() {
    currentTab = customSegmentedValues.first.obs;
  }
}
