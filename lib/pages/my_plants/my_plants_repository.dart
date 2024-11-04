part of 'my_plants_controller.dart';

class MyPlantsRepository {
  RxList<PlantModel> plantDataList = <PlantModel>[].obs;
  int plantPageNum = 1;
  RxBool plantIsLoading = false.obs;
  bool plantIsLastPage = false;
  final List<CustomSegmentedValue> customSegmentedValues = [CustomSegmentedValue('allPlants'.tr, '1'), CustomSegmentedValue('reminders'.tr, '2')];

  late Rx<CustomSegmentedValue> currentTab;

  MyPlantsRepository() {
    currentTab = customSegmentedValues.first.obs;
  }
}
