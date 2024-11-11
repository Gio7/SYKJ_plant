import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/my_plants/widgets/plant_item_more.dart';
import 'package:plant/widgets/empty_widget.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';

import 'identify_history_controller.dart';

class IdentifyHistoryPage extends StatelessWidget {
  const IdentifyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IdentifyHistoryController());
    final repository = controller.repository;
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: 'snapHistory'.tr),
        body: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              decoration: const BoxDecoration(color: UIColor.transparentPrimary40),
              alignment: Alignment.center,
              child: Text(
                'identifyHistoryListTips'.tr,
                style: TextStyle(
                  color: UIColor.c40BD95,
                  fontSize: 12,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: repository.dataList.isEmpty
                    ? EmptyWidget(
                        isLoading: repository.isLoading.value,
                        icon: 'images/icon/no_data_camera_histroy.png',
                      )
                    : EasyRefresh(
                        onRefresh: () {
                          controller.onRefresh();
                        },
                        onLoad: () {
                          controller.onLoad();
                        },
                        child: GroupedListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          separator: const SizedBox(height: 16),
                          groupItemBuilder: (_, model, __, groupEnd) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: groupEnd ? 4 : 0),
                              child: PlantItemMore(
                                model: model,
                                onTap: () => controller.onDetailById(model),
                              ),
                            );
                          },
                          itemComparator: (a, b) => a.createTimestamp.compareTo(b.createTimestamp),
                          elements: repository.dataList,
                          groupBy: (element) => element.createTimeYmd,
                          order: GroupedListOrder.DESC,
                          groupHeaderBuilder: (element) => Container(
                            height: 20.0,
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('images/icon/time.png', width: 20),
                                const SizedBox(width: 8),
                                Text(
                                  element.createTimeLocal,
                                  style: TextStyle(
                                    color: UIColor.c85B9A8,
                                    fontSize: 12,
                                    fontWeight: FontWeightExt.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
