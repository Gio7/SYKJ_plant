import 'package:flutter/cupertino.dart';

class NormalButton extends StatelessWidget {
  const NormalButton({
    super.key,
    this.onTap,
    required this.text,
    required this.textColor,
    required this.bgColor,
    this.bgColors,
    this.icon,
    this.width,
    this.iconWidget,
  });

  final List<Color>? bgColors;
  final Color bgColor;
  final String text;
  final Color textColor;
  final String? icon;
  final Widget? iconWidget;
  final double? width;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: bgColors != null ? null : bgColor,
          gradient: bgColors == null
              ? null
              : LinearGradient(
                  stops: const [-0.35, 1.0],
                  begin: const FractionalOffset(1, 0.5),
                  end: const FractionalOffset(0, 0.5),
                  colors: bgColors!,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(256),
          ),
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
