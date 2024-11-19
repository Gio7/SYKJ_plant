import 'package:flutter/cupertino.dart';
import 'package:plant/common/ui_color.dart';

class NormalButton extends StatelessWidget {
  const NormalButton({
    super.key,
    this.onTap,
    required this.text,
    this.textFontSize = 14,
    this.textColor = UIColor.white,
    this.bgColor = UIColor.primary,
    this.bgColors,
    this.icon,
    this.iconRight,
    this.width,
    this.iconWidget,
    this.borderRadius,
    this.paddingHorizontal = 16,
    this.height = 44,
  });

  final List<Color>? bgColors;
  final Color bgColor;
  final String text;
  final double textFontSize;
  final Color textColor;
  final String? icon;
  final String? iconRight;
  final Widget? iconWidget;
  final double? width;
  final Function()? onTap;
  final double? borderRadius;
  final double paddingHorizontal;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        decoration: BoxDecoration(
          color: bgColors != null ? null : bgColor,
          gradient: bgColors == null
              ? null
              : LinearGradient(
                  stops: const [-0.35, 1.0],
                  begin: const FractionalOffset(1, 0.5),
                  end: const FractionalOffset(0, 0.5),
                  colors: bgColors!,
                ),
          borderRadius: BorderRadius.circular(borderRadius ?? 256),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ImageIcon(AssetImage(icon!), color: textColor, size: 20),
            if (iconWidget != null) iconWidget!,
            if (icon != null || iconWidget != null) const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            if (iconRight != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ImageIcon(AssetImage(iconRight!), color: textColor, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
