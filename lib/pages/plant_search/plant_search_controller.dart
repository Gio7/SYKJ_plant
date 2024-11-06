import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/pages/plant_scan/info_identify_page.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/loading_dialog.dart';

import 'models/plant_search_model.dart';

part 'plant_search_repository.dart';

class PlantSearchController extends GetxController {
  final bool isActiveSearch;
  final String? categoryId;
  PlantSearchController([this.isActiveSearch = false, this.categoryId]);

  late PlantSearchRepository repository = PlantSearchRepository(isActiveSearch, categoryId);

  @override
  void onInit() {
    super.onInit();
    if (categoryId != null) {
      didSearch('', categoryId: categoryId, type: 0);
    }
  }

  Future<void> didSearch(String text, {String? categoryId, int type = 1}) async {
    repository.activeSearch.value = true;
    repository.searching.value = true;
    repository.searchText.value = text;
    repository.plantSearchList.value = [];
    try {
      final res = await Request.plantSearch(text,categoryId: categoryId,type: type);
      repository.plantSearchList.value = res.map((e) => PlantSearchModel.fromJson(e)).toList();
      repository.searching.value = false;
    } catch (e) {
      repository.plantSearchList.value = [];
      repository.searching.value = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> onDetailById(PlantSearchModel model) async{
    if (model.uniqueId == null) return;

    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    try {
      final res = await Request.getPlantByUniqueId(model.uniqueId!);
      final p = PlantInfoModel.fromJsonBySearch(res);
      final ctr = Get.put(PlantController(ShootType.identify, hasCamera: false));
      ctr.repository.plantInfo = p;
      Get.back();

      await Get.to(() => InfoIdentifyPage(hideBottom: true));
      ctr.dispose();
    } catch (e) {
      Get.back();
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
