import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/widgets.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';

class PlantEmptyWidget extends StatelessWidget {
  const PlantEmptyWidget({super.key, this.onBtnTap, this.iconImage = "images/icon/plants.png", required this.text, required this.btnText});
  final Function()? onBtnTap;
  final String iconImage;
  final String text;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: UIColor.transparent40,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        width: double.infinity,
        decoration: DottedDecoration(
          shape: Shape.box,
          color: UIColor.cAEE9CD,
          strokeWidth: 1,
          dash: const <int>[2, 2],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(iconImage, height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                text,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            NormalButton(
              onTap: onBtnTap,
              bgColor: UIColor.transparentPrimary40,
              text: btnText,
              textColor: UIColor.primary,
            ),
          ],
        ),
      ),
    );
  }
}
