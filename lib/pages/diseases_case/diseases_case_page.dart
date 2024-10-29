import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/diseases_case/diseases_case_controller.dart';
import 'package:plant/widgets/empty_widget.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';

class DiseasesCasePage extends StatelessWidget {
  const DiseasesCasePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiseasesCaseController());
    final repository = controller.repository;
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: title),
        body: Obx(
          () => SafeArea(
            child: repository.dataList.isEmpty
                ? EmptyWidget(isLoading: repository.isLoading.value)
                : EasyRefresh(
                    onRefresh: () {
                      controller.onRefresh();
                    },
                    onLoad: () {
                      controller.onLoad();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemBuilder: (_, i) {
                        final p = repository.dataList[i];
                        return _buildItem(p);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: repository.dataList.length,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        // TODO : 跳转H5落地页
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: UIColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: 'https://p2.ssl.qhimgs1.com/sdr/400__/t01e0d92fe46f5123ec.jpg',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'https://p2.ssl.qhimgs1.com/sdr/400__/t01e0d92fe46f5123ec.jpghttps://p2.ssl.qhimgs1.com/sdr/400__/t01e0d92fe46f5123ec.jpghttps://p2.ssl.qhimgs1.com/sdr/400__/t01e0d92fe46f5123ec.jpg',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: UIColor.c8E8B8B,
                    fontSize: 12,
                    fontWeight: FontWeightExt.medium,
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
