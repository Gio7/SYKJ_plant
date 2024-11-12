import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/db_core.dart';
import 'package:plant/pages/plant_search/models/plant_type_model.dart';
import 'package:plant/pages/diagnose_home/categorized_feed_model.dart';
import 'package:sqflite/sqflite.dart';

class MainController extends GetxController {
  late TabController tabController;

  final RxList<CategorizedFeedModel> categorizedFeedList = RxList<CategorizedFeedModel>([]);
  final RxList<PlantTypeModel> plantTypeList = RxList<PlantTypeModel>([]);

  Database? _database;

  @override
  onInit() {
    super.onInit();
    DbCore.database.then((db) {
      _database = db;
      getSearchList();
    });
  }

  Future<void> getDiseaseHome() async {
    try {
      final dbRes = await getCategoriesByDB();

      if (dbRes.isNotEmpty) {
        categorizedFeedList.value = dbRes.map((e) => CategorizedFeedModel.fromJson(e)).toList();
      }

      final res = await Request.getDiseaseHome();
      categorizedFeedList.value = res.map((e) => CategorizedFeedModel.fromJson(e)).toList();

      insertCategoriesAndItems(categorizedFeedList);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> getSearchList() async {
    try {
      final dbRes = await getPlantTypesByDB();

      if (dbRes.isNotEmpty) {
        plantTypeList.value = dbRes.map((e) => PlantTypeModel.fromJson(e)).toList();
      }

      final res = await Request.getSearchList();
      plantTypeList.value = res.map((e) => PlantTypeModel.fromJson(e)).toList();

      insertOrUpdatePlantType(res);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPlantTypesByDB() async {
    final res = await _database?.query('search_category');
    return res ?? [];
  }

  Future<void> insertOrUpdatePlantType(List<dynamic> plantTypeList) async {
    // 插入前清空数据，避免数据更新后存在错误数据
    await _database?.delete('search_category');
    final batch = _database?.batch();

    for (final plantType in plantTypeList) {
      batch?.insert(
        'search_category',
        plantType,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch?.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCategoriesByDB() async {
    final res = await _database?.query('disease_category');
    return res ?? [];
  }

  Future<List<Map<String, dynamic>>> getCategoryItemByDB(int categoryId) async {
    final res = await _database?.query('disease_category_item',where: 'categoryId = ?',whereArgs: [categoryId]);
    return res ?? [];
  }

  Future<void> insertCategoriesAndItems(List<CategorizedFeedModel> categoryList) async {
    // 插入前清空数据，避免数据更新后存在错误数据
    await _database?.delete('disease_category_item');
    await _database?.delete('disease_category');
    await _database?.transaction((txn) async {
      for (final categoryData in categoryList) {
        await txn.insert('disease_category', categoryData.toMapDB(), conflictAlgorithm: ConflictAlgorithm.replace);

        for (final itemData in categoryData.item) {
          await txn.insert('disease_category_item', itemData.toMapDB(categoryData.categoryId), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
  }

}
