import 'package:flutter/cupertino.dart';

class NormalButton extends StatelessWidget {
  const NormalButton({
    super.key,
    required this.bgColor,
    required this.text,
    required this.textColor,
    this.icon,
    this.width,
    this.onTap,
  });

  final Color bgColor;
  final String text;
  final Color textColor;
  final String? icon;
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
          color: bgColor,
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
            if (icon != null) const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
