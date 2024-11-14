import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/api/db_server.dart';
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

  /// 获取搜索分类列表
  Future<void> getSearchList() async {
    try {
      final dbRes = await DbServer.getPlantTypesByDB();

      if (dbRes.isNotEmpty) {
        plantTypeList.value = dbRes.map((e) => PlantTypeModel.fromJson(e)).toList();
      }

      final res = await Request.getSearchList();
      plantTypeList.value = res.map((e) => PlantTypeModel.fromJson(e)).toList();

      DbServer.insertOrUpdatePlantType(res);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  /// 病害首页
  Future<void> getDiseaseHome() async {
    try {
      final dbRes = await DbServer.getCategoriesByDB();

      if (dbRes.isNotEmpty) {
        categorizedFeedList.value = dbRes.map((e) => CategorizedFeedModel.fromJson(e)).toList();
      }

      final res = await Request.getDiseaseHome();
      categorizedFeedList.value = res.map((e) => CategorizedFeedModel.fromJson(e)).toList();

      DbServer.insertCategoriesAndItems(categorizedFeedList);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
