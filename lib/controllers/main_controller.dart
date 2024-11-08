import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/pages/plant_search/models/plant_type_model.dart';
import 'package:plant/pages/diagnose_home/categorized_feed_model.dart';

class MainController extends GetxController {
  late TabController tabController;

  final RxList<CategorizedFeedModel> categorizedFeedList = RxList<CategorizedFeedModel>([]);
  final RxList<PlantTypeModel> plantTypeList = RxList<PlantTypeModel>([]);

  @override
  onInit() {
    super.onInit();
    getSearchList();
  }

  Future<void> getDiseaseHome() async {
    final res = await Request.getDiseaseHome();
    categorizedFeedList.value = res.map((e) => CategorizedFeedModel.fromJson(e)).toList();
  }

  Future<void> getSearchList() async {
    try {
      final res = await Request.getSearchList();
      plantTypeList.value = res.map((e) => PlantTypeModel.fromJson(e)).toList();
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
