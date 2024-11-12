import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/plant_search/models/plant_search_model.dart';
import 'package:plant/pages/plant_search/plant_search_controller.dart';
import 'package:plant/widgets/empty_widget.dart';
import 'package:plant/widgets/highlight_text.dart';

class PlantSearchResultList extends StatelessWidget {
  PlantSearchResultList({super.key, required this.searchText});
  final String searchText;
  final plantSearchCtr = Get.find<PlantSearchController>();

  @override
  Widget build(BuildContext context) {
    final repository = plantSearchCtr.repository;
    return Obx(() {
      if (!repository.searching.value && repository.plantSearchList.isEmpty) {
        return EmptyWidget(
          isLoading: false,
          icon: 'images/icon/no_data_search.png',
          text: 'noResults'.tr,
          subText: 'noResultsTips'.tr,
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemBuilder: (_, i) => _buildItem(repository.plantSearchList[i]),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: repository.plantSearchList.length,
      );
    });
  }

  Widget _buildItem(PlantSearchModel model) {
    return GestureDetector(
      onTap: () => plantSearchCtr.onDetailById(model),
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: ShapeDecoration(
          color: UIColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: model.primaryImageUrl ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                errorWidget: (context, url, error) => Image.asset('images/icon/error_image.png'),
                placeholder: (context, url) => const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: HighlightText(text: model.title, keyword: searchText)),
            const SizedBox(width: 12),
            Image.asset(
              'images/icon/arrow_right.png',
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
