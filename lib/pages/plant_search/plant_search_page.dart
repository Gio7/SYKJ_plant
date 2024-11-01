import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/plant_search/plant_search_controller.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';
import 'package:plant/widgets/search_bar_widget.dart';

import 'widgets/plant_categries_list.dart';
import 'widgets/plant_search_result_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.isActiveSearch});
  final bool isActiveSearch;

  @override
  Widget build(BuildContext context) {
    final plantSearchCtr = Get.put(PlantSearchController(isActiveSearch));
    final repository = plantSearchCtr.repository;
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(title: 'plantSearch'.tr),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchWidget(
                hintText: 'search'.tr,
                onSubmitted: (p0) {
                  plantSearchCtr.didSearch(p0);
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                if (repository.activeSearch.value) {
                  return PlantSearchResultList(
                    searchText: repository.searchText.value,
                  );
                } else {
                  return const SingleChildScrollView(
                    child: PlantCategriesWidget(),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
