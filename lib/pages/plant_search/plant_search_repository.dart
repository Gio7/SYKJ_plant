part of 'plant_search_controller.dart';

class PlantSearchRepository {
  RxBool activeSearch = false.obs;
  RxString searchText = ''.obs;
  String? categoryId;
  RxList<PlantSearchModel> plantSearchList = <PlantSearchModel>[].obs;
  RxBool searching = false.obs;

  PlantSearchRepository(bool isActiveSearch, String? id) {
    activeSearch.value = isActiveSearch;
    categoryId = id;
  }
}
