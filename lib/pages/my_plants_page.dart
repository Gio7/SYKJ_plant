import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/loading_dialog.dart';
import 'package:plant/components/show_dialog.dart';
import 'package:plant/controllers/plant_controller.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/pages/info_identify_page.dart';

import 'shoot_page.dart';
import '../components/user_nav_bar.dart';

class MyPlantsPage extends StatefulWidget {
  const MyPlantsPage({super.key});

  @override
  State<MyPlantsPage> createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  List<PlantModel> _dataList = [];
  int _pageNum = 1;
  bool _isLoading = false;
  bool _isLastPage = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    _isLastPage = false;
    setState(() {
      // _dataList.clear();
      _isLoading = true;
    });
    _pageNum = 1;
    final res = await Request.getPlantScanHistory(_pageNum);
    _isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    setState(() {
      _isLoading = false;
      _dataList = rows;
    });
  }

  Future<void> _onLoad() async {
    if (_isLastPage) return;
    _pageNum++;
    final res = await Request.getPlantScanHistory(_pageNum);
    _isLastPage = res['lastPage'];
    final rows = (res['rows'] as List).map((plant) => PlantModel.fromJson(plant)).toList();
    setState(() {
      _dataList.addAll(rows);
    });
  }

  Future<void> getPlantDetailByRecord(PlantModel model) async {
    Get.dialog(const LoadingDialog(), barrierDismissible: false);
    try {
      final res = await Request.getPlantDetailByRecord(model.id!);
      final p = PlantInfoModel.fromJson(res);
      final ctr = Get.put(PlantController());
      ctr.thumbnailUrl = model.thumbnail;
      ctr.plantInfo = p;
      Get.back();
      
      await Get.to(() => InfoIdentifyPage(hideBottom: true));
      ctr.dispose();
    } catch (e) {
      Get.back();
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UserNavBar(needUser: true),
        Container(
          margin: const EdgeInsets.only(left: 24, top: 16),
          child: Text(
            'myPlants'.tr,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: _dataList.isEmpty
              ? _empty
              : EasyRefresh(
                  onRefresh: () {
                    _onRefresh();
                  },
                  onLoad: () {
                    _onLoad();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    itemBuilder: (_, i) {
                      final p = _dataList[i];
                      return _buildItem(p);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemCount: _dataList.length,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(PlantModel model) {
    return GestureDetector(
      onTap: () => getPlantDetailByRecord(model),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: ShapeDecoration(
          color: UIColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: model.thumbnail ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.plantName ?? '',
                    style: const TextStyle(
                      color: UIColor.c15221D,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${'addedAt'.tr} ${model.createTimeLoacal}',
                    style: TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 12,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _onMore(model);
              },
              child: Image.asset(
                'images/icon/more.png',
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _empty {
    if (_isLoading) return const LoadingDialog();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: DottedDecoration(shape: Shape.box, color: UIColor.cAEE9CD, strokeWidth: 1, dash: const <int>[2, 2], borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/icon/plants.png', height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'youHaveNoPlants'.tr,
              style: const TextStyle(
                color: UIColor.c15221D,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          NormalButton(
            onTap: () {
              Get.to(() => const ShootPage());
            },
            bgColor: UIColor.transparentPrimary40,
            text: 'addPlant'.tr,
            textColor: UIColor.primary,
          ),
        ],
      ),
    );
  }

  void _onMore(PlantModel model) {
    Get.bottomSheet(
      BottomPopOptions(
        children: [
          SizedBox(
            width: double.infinity,
            child: NormalButton(
              onTap: () {
                Get.back();
                Get.dialog(
                  TextFieldDialog(
                    title: 'setYourPlantName'.tr,
                    confirmText: 'save'.tr,
                    cancelText: 'cancel'.tr,
                    value: model.plantName,
                    onConfirm: (String v) async {
                      Get.back();
                      Request.plantScanRename(model.id!, v);
                      setState(() {
                        model.plantName = v;
                      });
                    },
                  ),
                );
              },
              text: 'rename'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/edit.png', width: 28),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: NormalButton(
              onTap: () async {
                Get.back();
                Get.dialog(
                  NormalDialog(
                    title: 'warning'.tr,
                    confirmText: 'delete'.tr,
                    cancelText: 'cancel'.tr,
                    subText: 'deletePlantTips'.tr,
                    icon: Image.asset('images/icon/delete.png', height: 70),
                    confirmPositionLeft: false,
                    onConfirm: () async {
                      Get.back();
                      Request.plantScanDelete(model.id!);
                      setState(() {
                        _dataList.removeWhere((element) => element.id == model.id);
                      });
                    },
                  ),
                );
              },
              text: 'removeBtn'.tr,
              textColor: UIColor.c15221D,
              bgColor: UIColor.white,
              iconWidget: Image.asset('images/icon/delete_red.png', width: 28),
            ),
          ),
        ],
      ),
    );
  }
}
