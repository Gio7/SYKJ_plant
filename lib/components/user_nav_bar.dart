import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/set_page.dart';
import 'package:plant/pages/shop/shop_view.dart';

class UserNavBar extends StatelessWidget {
  const UserNavBar({super.key, this.needUser = false});
  final bool needUser;

  @override
  Widget build(BuildContext context) {
     return Obx(
      () => Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!(Get.find<UserController>().userInfo.value.isRealVip))
              GestureDetector(
                onTap: () {
                  Get.to(() => ShopPage());
                },
                child: Image.asset(
                  'images/icon/pro.png',
                  height: 30,
                ),
              )
            else
              const SizedBox(),
            const Spacer(),
            if (needUser)
              GestureDetector(
                onTap: () {
                  Get.to(() => const SetPage());
                  // if (Get.find<UserController>().isLogin.value) {
                  // } else {
                  //   Get.to(() => const LoginPage(), fullscreenDialog: true, routeName: 'login_page');
                  // }
                },
                child: Image.asset(
                  'images/icon/user.png',
                  height: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
