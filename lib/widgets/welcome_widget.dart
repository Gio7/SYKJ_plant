import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/plant_search/plant_search_page.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
      decoration: ShapeDecoration(
        color: UIColor.transparent40,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: UIColor.white),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            child: Obx(
              () => Text(
                '${'hi'.tr}${Get.find<UserController>().userInfo.value.nickname ?? 'plantLover'.tr}',
                style: TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 14,
                  fontWeight: FontWeightExt.medium,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 24,
            child: Row(
              children: [
                Text(
                  'welcome'.tr,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset('images/icon/sun.png', height: 24),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => const SearchPage(isActiveSearch: false));
              FireBaseUtil.logEvent(EventName.homeSearch);
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(left: 12),
              margin: const EdgeInsets.only(top: 16),
              decoration: ShapeDecoration(
                color: UIColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Image.asset('images/icon/search.png', height: 18),
                  const SizedBox(width: 8),
                  Text(
                    'search'.tr,
                    style: TextStyle(
                      color: UIColor.cB3B3B3,
                      fontSize: 14,
                      fontWeight: FontWeightExt.medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
