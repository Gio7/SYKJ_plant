import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/user_nav_bar.dart';
import 'package:plant/widgets/welcome_widget.dart';

import '../plant_scan/shoot_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
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
              child: Image.asset(image),
            ),
          ],
        ),
      ),
    );
  }
}
