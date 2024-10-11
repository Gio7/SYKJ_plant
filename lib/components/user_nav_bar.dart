import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/pages/set_page.dart';

class UserNavBar extends StatelessWidget {
  const UserNavBar({super.key, this.needUser = false});
  final bool needUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          if (needUser)
            GestureDetector(
              onTap: () {
                Get.to(() => const SetPage());
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
