import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final Widget? leftWidget;
  final Widget? rightWidget;

  const NavBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.backgroundColor,
    this.leftWidget,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: 56 + Get.mediaQuery.padding.top,
      child: Padding(
        padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
        child: SizedBox(
          height: 56,
          width: Get.mediaQuery.size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: leftWidget ??
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const ImageIcon(
                        AssetImage('images/icon/nav_back.png'),
                        size: 32,
                        color: UIColor.c15221D,
                      ),
                    ),
              ),
              if (rightWidget != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: rightWidget,
                ),
              if (titleWidget != null) Center(child: titleWidget),
              if (title != null)
                Center(
                  child: Text(
                    title!,
                    style: titleStyle ??
                        const TextStyle(
                          color: UIColor.c15221D,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Get.mediaQuery.padding.top + 56);
}
