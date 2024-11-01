part of 'plant_search_controller.dart';

class PlantSearchRepository {
  RxBool activeSearch = false.obs;
  RxString searchText = ''.obs;

  PlantSearchRepository(bool isActiveSearch) {
    activeSearch.value = isActiveSearch;
  }
}
