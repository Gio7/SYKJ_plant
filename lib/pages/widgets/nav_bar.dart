import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/login/login_page.dart';
import 'package:plant/pages/set_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, this.needUser = false});
  final bool needUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!(Get.find<UserController>().isLogin.value))
            GestureDetector(
              onTap: () {
                if (Get.find<UserController>().isLogin.value) {
                } else {
                  Get.to(() => const LoginPage());
                }
              },
              child: Image.asset(
                'images/icon/pro.png',
                height: 30,
              ),
            ),
          const Spacer(),
          if (needUser)
            GestureDetector(
              onTap: () {
                if (Get.find<UserController>().isLogin.value) {
                  Get.to(() => const SetPage());
                } else {
                  Get.to(() => const LoginPage());
                }
              },
              child: Image.asset(
                'images/icon/user.png',
                height: 32,
              ),
            ),
        ],
      ),
    );
  }
}
