import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/router/app_pages.dart';
import 'package:plant/widgets/empty_widget.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';
import 'package:plant/widgets/show_dialog.dart';

import 'widgets/plant_item_more.dart';

class PlantsChosePage extends StatefulWidget {
  const PlantsChosePage({super.key});

  @override
  State<PlantsChosePage> createState() => _PlantsChosePageState();
}

class _PlantsChosePageState extends State<PlantsChosePage> {
  List<PlantModel>? _dataList;
  int _pageNum = 1;
  bool _isLastPage = false;
  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    _isLastPage = false;
    _pageNum = 1;
    final res = await Request.getPlantScanHistory(_pageNum);
    _isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    setState(() => _dataList = rows);
  }

  Future<void> onLoad() async {
    if (_isLastPage) return;
    _pageNum++;
    final res = await Request.getPlantScanHistory(_pageNum);
    _isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    setState(() => _dataList?.addAll(rows));
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: 'chosePlants'.tr),
        body: _dataList == null || _dataList!.isEmpty
            ? EmptyWidget(
                isLoading: _dataList == null,
                icon: 'images/icon/no_data_camera_histroy.png',
              )
            : EasyRefresh(
                onRefresh: () async {
                  await onRefresh();
                },
                onLoad: () async {
                  await onLoad();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) {
                    return PlantItemMore(
                      model: _dataList![i],
                      hasCreateTime: true,
                      onTap: () {
                        bool isRealVip = false;
                        if (Get.isRegistered<UserController>()) {
                          isRealVip = Get.find<UserController>().userInfo.value.isRealVip;
                        }
                        if (isRealVip) {
                          Get.offNamed(AppRoutes.reminderEdit, arguments: {'plantModel': _dataList![i]});
                        } else {
                          NormalDialog.showChargeableFeature();
                        }
                      },
                    );
                  },
                  itemCount: _dataList?.length ?? 0,
                ),
              ),
      ),
    );
  }
}
