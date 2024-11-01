import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/plant_search/plant_search_controller.dart';
import 'package:plant/pages/plant_search/plant_search_page.dart';

class PlantCategriesWidget extends StatelessWidget {
  const PlantCategriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 24,
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Image.asset(
                'images/icon/detail_characteristics.png',
                width: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'categories'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          crossAxisCount: 2,
          childAspectRatio: 154 / 170,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          children: [1, 2, 3, 3, 3, 3, 3, 3, 3, 32, 2]
              .map(
                (e) => _buildItem(e),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildItem(dynamic item) {
    return GestureDetector(
      onTap: () async {
        if (Get.isRegistered<PlantSearchController>()) {
          Get.find<PlantSearchController>().repository.activeSearch.value = true;
        } else {
          await Get.to(() => const SearchPage(isActiveSearch: true));
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: 'https://p0.ssl.qhimgs1.com/t03ba55714bfa2dcb64.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              gradient: const LinearGradient(
                begin: Alignment(0.0, 0.05),
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0x99000000)],
              ),
            ),
          ),
          const Positioned(
            left: 14,
            right: 0,
            bottom: 16,
            child: Text(
              'categoryName',
              style: TextStyle(
                color: UIColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
