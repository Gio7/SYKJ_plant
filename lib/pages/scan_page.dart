import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/scanning_effect/scanning_effect.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key, required this.photoImage});
  final Uint8List photoImage;

  @override
  Widget build(BuildContext context) {
    final width = Get.width - 116;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/icon/scan_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'weScanForYou'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: UIColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'scanTips'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: UIColor.transparent60,
              fontSize: 14,
              fontWeight: FontWeightExt.medium,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 46),
          Container(
            width: width,
            height: width,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ScanningEffect(
              scanningColor: UIColor.primary,
              enableBorder: false,
              scanningLinePadding: EdgeInsets.zero,
              delay: Duration.zero,
              child: Image.memory(photoImage),
            ),
          ),
          const SizedBox(height: 50),
          _buildRow(true, 'analyzingImage'.tr),
          const SizedBox(height: 16),
          _buildRow(false, 'detectingLeaves'.tr),
          const SizedBox(height: 16),
          _buildRow(false, 'identifyingPlant'.tr),
        ],
      ),
    );
  }

  Widget _buildRow(bool isDone, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isDone)
          Image.asset('images/icon/check.png', width: 24)
        else
          const SizedBox(width: 21, height: 21, child: CircularProgressIndicator(color: UIColor.primary, strokeWidth: 3)),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: UIColor.transparent60,
            fontSize: 14,
            fontWeight: FontWeightExt.medium,
            decoration: TextDecoration.none,
          ),
        )
      ],
    );
  }
}
