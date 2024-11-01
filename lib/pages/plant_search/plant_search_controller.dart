import 'package:get/get.dart';

part 'plant_search_repository.dart';

class PlantSearchController extends GetxController {

  final bool isActiveSearch;
  PlantSearchController([this.isActiveSearch = false]);

  late PlantSearchRepository repository = PlantSearchRepository(isActiveSearch);

  void didSearch(String text) {
    repository.searchText.value = text;
    repository.activeSearch.value = true;
  }
}