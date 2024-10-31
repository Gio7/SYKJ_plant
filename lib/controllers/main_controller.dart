import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/pages/diagnose_home/categorized_feed_model.dart';

class MainController extends GetxController {
  late TabController tabController;
  
  final RxList<CategorizedFeedModel> categorizedFeedList = RxList<CategorizedFeedModel>([]);

  Future<void> getDiseaseHome() async{
    final res = await Request.getDiseaseHome();
    categorizedFeedList.value = res.map((e) => CategorizedFeedModel.fromJson(e)).toList();
  }
}
