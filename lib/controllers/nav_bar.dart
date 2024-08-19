import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const ImageIcon(
              AssetImage('images/icon/nav_back.png'),
              size: 32,
              color: UIColor.c15221D,
            ),
          ),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                color: UIColor.c15221D,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
