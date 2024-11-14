import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/pages/light_sensor/light_page.dart';
import 'package:plant/pages/my_plants/my_plants_controller.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/pages/plant_search/widgets/plant_categries_list.dart';
import 'package:plant/widgets/user_nav_bar.dart';
import 'package:plant/widgets/welcome_widget.dart';

import '../plant_scan/shoot_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const UserNavBar(needUser: true),
          const WelcomeWidget(),
          const SizedBox(height: 24),
          Container(
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset('images/icon/camera2.png', width: 24),
                const SizedBox(width: 8),
                Text(
                  'getStarted'.tr,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                const SizedBox(width: 20),
                _buildItem(
                  'images/icon/camera_search_1.png',
                  'identify'.tr,
                  'images/icon/identify.png',
                  () {
                    FireBaseUtil.logEvent(EventName.homeIdentify);
                    Get.to(() => const ShootPage());
                  },
                ),
                const SizedBox(width: 12),
                _buildItem(
                  'images/icon/shop_diagnosis.png',
                  'diagnose'.tr,
                  'images/icon/diagnose.png',
                  () {
                    FireBaseUtil.logEvent(EventName.homeDianose);
                    Get.to(() => const ShootPage(shootType: ShootType.diagnose));
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          _buildCareTools(),
          const PlantCategriesWidget()
        ],
      ),
    );
  }

  Widget _buildCareTools() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'images/icon/care_tools.png',
                width: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'careTools'.tr,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                _buildCareToolsItem(
                  'images/icon/reminders.png',
                  'images/icon/reminders2.png',
                  'reminders'.tr,
                  [const Color(0xFFD9F8E9), const Color(0xFFAEE9CD)],
                  () {
                    Get.find<MainController>().tabController.index = 3;
                    if (Get.isRegistered<MyPlantsController>()) {
                      final c = Get.find<MyPlantsController>();
                      c.onSegmentChange(c.repository.customSegmentedValues[1]);
                    }
                  },
                ),
                const SizedBox(width: 12),
                _buildCareToolsItem(
                  'images/icon/sun3.png',
                  'images/icon/sun2.png',
                  'lightMeter'.tr,
                  [const Color(0xFFF8EFD9), const Color(0xFFE9DFAE)],
                  () {
                    Get.to(() => LightPage());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(String icon, String title, String image, Function()? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 160,
              decoration: ShapeDecoration(
                color: UIColor.cEDEDED,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 36,
                decoration: const ShapeDecoration(
                  color: UIColor.c8FCCB9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage(icon),
                      color: UIColor.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: UIColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 42,
              child: Image.asset(image,height: 160),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareToolsItem(String icon, String bgIcon, String title, List<Color> colors, Function()? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 80,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              height: 80,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                ),
                child: Image.asset(bgIcon),
              ),
            ),
            Positioned(
              left: 14,
              top: -14,
              height: 60,
              child: Image.asset(icon),
            ),
            Positioned(
              left: 16,
              bottom: 12,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF454944),
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
