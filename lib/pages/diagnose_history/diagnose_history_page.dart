import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/diagnose_history/diagnose_history_controller.dart';
import 'package:plant/pages/shop/shop_page.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/empty_widget.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';

import 'diagnose_history_model.dart';

class DiagnoseHistoryPage extends StatelessWidget {
  const DiagnoseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiagnoseHistoryController());
    final repository = controller.repository;

    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: 'diagnosisHistory'.tr),
        body: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              decoration: const BoxDecoration(color: UIColor.transparentPrimary40),
              alignment: Alignment.center,
              child: Obx(() {
                final userCtr = Get.find<UserController>();
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        userCtr.userInfo.value.isRealVip ? 'diagnosisHistoryListTips'.tr : 'aboutToExpire'.tr,
                        style: TextStyle(
                          color: UIColor.c40BD95,
                          fontSize: 12,
                          fontWeight: FontWeightExt.medium,
                        ),
                      ),
                    ),
                    if (!userCtr.userInfo.value.isRealVip)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: NormalButton(
                          text: 'save'.tr,
                          height: 28,
                          onTap: () {
                            Get.to(
                              () => const ShopPage(
                                formPage: ShopFormPage.history,
                              ),
                              fullscreenDialog: true,
                            );
                          },
                        ),
                      ),
                  ],
                );
              }),
            ),
            Obx(
              () => Expanded(
                child: repository.dataList.isEmpty
                    ? EmptyWidget(isLoading: repository.isLoading.value)
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
                              child: _buildItem(model, controller),
                            );
                          },
                          itemComparator: (a, b) => a.createTimestamp.compareTo(b.createTimestamp),
                          elements: repository.dataList,
                          groupBy: (element) => element.createTimeYmd,
                          order: GroupedListOrder.DESC,
                          groupHeaderBuilder: (value) => Container(
                            height: 20.0,
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('images/icon/time.png', width: 20),
                                const SizedBox(width: 8),
                                Text(
                                  value.createTimeLocal,
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

  Widget _buildItem(DiagnosisHistoryModel model, DiagnoseHistoryController controller) {
    return GestureDetector(
      onTap: () => controller.onDetailById(model.id),
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: ShapeDecoration(
          color: UIColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: model.thumbnail == null
                  ? const SizedBox()
                  : CachedNetworkImage(
                      imageUrl: model.thumbnail!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                model.plantName ?? '',
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
