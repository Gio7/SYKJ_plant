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
  final bool topSafeArea;
  final Function()? onBack;

  const NavBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.backgroundColor,
    this.leftWidget,
    this.rightWidget,
    this.topSafeArea = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final double top = topSafeArea ? Get.mediaQuery.padding.top : 0;
    return Container(
      color: backgroundColor,
      height: 56 + top,
      child: Padding(
        padding: EdgeInsets.only(top: top),
        child: SizedBox(
          height: 56,
          width: Get.mediaQuery.size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: leftWidget ??
                    IconButton(
                      onPressed: () => onBack?.call() ?? Get.back(),
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
  Size get preferredSize => Size.fromHeight((topSafeArea ? Get.mediaQuery.padding.top : 0) + 56);
}
