part of 'my_plants_controller.dart';

class MyPlantsRepository {
  RxList<PlantModel> plantDataList = <PlantModel>[].obs;
  int plantPageNum = 1;
  RxBool plantIsLoading = false.obs;
  bool plantIsLastPage = false;
  final List<CustomSegmentedValue> customSegmentedValues = [CustomSegmentedValue('allPlants'.tr, '1'), CustomSegmentedValue('reminders'.tr, '2')];

  late Rx<CustomSegmentedValue> currentTab;

  // TODO 更换类型
  RxList<dynamic> reminderDataList = <dynamic>[].obs;
  int reminderPageNum = 1;
  RxBool reminderIsLoading = false.obs;
  bool reminderIsLastPage = false;

  MyPlantsRepository() {
    currentTab = customSegmentedValues.first.obs;
  }
}
