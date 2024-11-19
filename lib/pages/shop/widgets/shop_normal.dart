import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/member_product_model.dart';
import 'package:plant/pages/shop/shop_controller.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';

class ShopNormal extends StatelessWidget {
  const ShopNormal({super.key, required this.controller});
  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<String> tips = [
        'unlmitedIdengtify'.tr,
        'enhanceFaster'.tr,
        'botanistSupport'.tr,
        'remindersForCare'.tr,
      ];
      if (controller.state.currentProduct.value.isFreeTrial) {
        tips.insert(0, 'vipFree'.tr);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('images/icon/shop_head.png', height: 142),
                  const SizedBox(height: 18),
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
                                child: buildRow(tips[i]),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  controller.state.isInRequest.value
                      ? const LoadingDialog()
                      : Column(
                          children: controller.state.productList!
                              .map(
                                (e) => buildShopItem(
                                  isSelected: controller.state.currentProduct.value == e,
                                  e: e,
                                ),
                              )
                              .toList(),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: controller.state.currentProduct.value.isFreeTrial
                ? _buildBtn()
                : NormalButton(
                    text: 'continue'.tr,
                    textFontSize: 16,
                    textColor: UIColor.white,
                    bgColor: UIColor.primary,
                    onTap: () => controller.subscribe(),
                  ),
          ),
          const SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16),
          //   child: Text(
          //     'subscribeTips'.tr,
          //     style: TextStyle(
          //       color: UIColor.cBDBDBD,
          //       fontSize: 12,
          //       fontWeight: FontWeightExt.medium,
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }

  Widget _buildBtn() {
    return GestureDetector(
      onTap: () => controller.subscribe(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: UIColor.primary,
          borderRadius: BorderRadius.circular(256),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'startFreeTrial'.tr,
              style: const TextStyle(
                color: UIColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              'cancelAnytime'.tr,
              style: const TextStyle(
                color: UIColor.transparent60,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildRow(String text) {
    return Row(
      children: [
        Image.asset('images/icon/check.png', height: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: UIColor.c15221D,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget buildShopItem({
    required bool isSelected,
    required MemberProductModel e,
  }) {
    Color borderColor;
    Color titleColor;
    Color amountColor;
    String rightIcon;
    if (isSelected) {
      borderColor = UIColor.c40BD95;
      titleColor = UIColor.white;
      amountColor = UIColor.transparent70;
      rightIcon = 'images/icon/check_circle.png';
    } else {
      borderColor = UIColor.cE5E5E5;
      titleColor = UIColor.c15221D;
      amountColor = UIColor.c8E8B8B;
      rightIcon = 'images/icon/unchecked_circle.png';
    }
    return GestureDetector(
      onTap: () => controller.selectProduct(e),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        constraints: const BoxConstraints(minHeight: 67),
        decoration: ShapeDecoration(
          color: isSelected ? null : Colors.white,
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [UIColor.cAEE9CD, UIColor.c40BD95],
                )
              : null,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      e.isFreeTrial ? 'newFreeTrial'.tr : e.unitSingleStr,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    e.isFreeTrial ? "${'then'.tr} ${e.unitStr}" : e.unitStr,
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(rightIcon, height: 20),
          ],
        ),
      ),
    );
  }
}
