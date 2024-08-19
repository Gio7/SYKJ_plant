import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/user_controller.dart';

import 'login/login_page.dart';
import 'set_page.dart';
import '../controllers/user_nav_bar.dart';

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
                  if (Get.find<UserController>().isLogin.value) {
                    Get.to(() => const SetPage());
                  } else {
                    Get.to(() => const LoginPage(), fullscreenDialog: true);
                  }
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
        Row(
          children: [
            const SizedBox(width: 20),
            Expanded(child: Image.asset('images/icon/identify.png')),
            const SizedBox(width: 6),
            Expanded(child: Image.asset('images/icon/diagnose.png')),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
