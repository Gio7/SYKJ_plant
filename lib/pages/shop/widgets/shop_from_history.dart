import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/shop/shop_controller.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';

class ShopFromHistory extends StatelessWidget {
  const ShopFromHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopController>();
    final List<String> tips = [
      'unlmitedIdengtify'.tr,
      'enhanceFaster'.tr,
      'botanistSupport'.tr,
      'remindersForCare'.tr,
    ];

    return Obx(() {
      final isFreeTrial = controller.state.currentProduct.value?.isTrialProduct == true;
      if (isFreeTrial) {
        tips.insert(0, 'vipFree'.tr);
      }
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'images/icon/shop_from_history.png',
                    height: 120,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'historyVipTips1'.tr,
                    style: const TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.state.historyVipTips2.value,
                    style: const TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'benefitsPro'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: UIColor.c15221D,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: UIColor.transparent60,
                    ),
                    child: Container(
                      decoration: DottedDecoration(
                        shape: Shape.box,
                        color: UIColor.cAEE9CD,
                        strokeWidth: 1,
                        dash: const <int>[2, 2],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      child: UnconstrainedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < tips.length; i++)
                              Padding(
                                padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
                                child: Row(
                                  children: [
                                    Image.asset('images/icon/check.png', height: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      tips[i],
                                      style: const TextStyle(
                                        color: UIColor.c15221D,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              controller.state.priceIntroductionText.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UIColor.c8E8B8B,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: controller.state.historyVipTips2.value.isNotEmpty
                ? NormalButton(
                    text: isFreeTrial ? 'startFreeTrial'.tr : 'goProNow'.tr,
                    textFontSize: 16,
                    textColor: UIColor.white,
                    bgColor: UIColor.primary,
                    onTap: () => controller.subscribe(),
                  )
                : const LoadingDialog(),
          ),
        ],
      );
    });
  }
}
