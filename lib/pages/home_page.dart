import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/user_nav_bar.dart';

import 'set_page.dart';
import 'shoot_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserNavBar(),
        Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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
                    child: Text(
                      '${'hi'.tr}${'plantLover'.tr}',
                      style: TextStyle(
                        color: UIColor.c15221D,
                        fontSize: 14,
                        fontWeight: FontWeightExt.medium,
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
                  )
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  FireBaseUtil.logEvent(EventName.homeSettingBtn);
                  Get.to(() => const SetPage());
                  // if (Get.find<UserController>().isLogin.value) {
                  // } else {
                  //   Get.to(() => const LoginPage(), fullscreenDialog: true, routeName: 'login_page');
                  // }
                },
                child: Image.asset('images/icon/user2.png', width: 48),
              ),
            ),
          ],
        ),
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
                  Get.to(() => const ShootPage(shootType: 'diagnose'));
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
