import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';
import 'package:plant/components/loading_dialog.dart';
import 'package:plant/components/nav_bar.dart';

import 'shop_controller.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key});

  final controller = Get.put(ShopController());
  final state = Get.find<ShopController>().state;

  @override
  Widget build(BuildContext context) {
    controller.getShopList();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.28, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [UIColor.cD9F0E5, UIColor.white],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: UIColor.transparent,
          appBar: NavBar(
            leftWidget: IconButton(
              onPressed: () => Get.back(),
              icon: const ImageIcon(
                AssetImage('images/icon/close.png'),
                size: 32,
                color: UIColor.c15221D,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          Image.asset('images/icon/shop_head.png', height: 142),
                          const SizedBox(height: 12),
                          Text(
                            'getUnlimitedAccess'.tr,
                            style: const TextStyle(
                              color: UIColor.c15221D,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 24),
                          UnconstrainedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildRow(
                                  'images/icon/detail_characteristics.png',
                                  'unlimitedPlantIdentify'.tr,
                                ),
                                const SizedBox(height: 14),
                                buildRow(
                                  'images/icon/shop_diagnosis.png',
                                  'autoDiagnosisOfPlantProblem'.tr,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          state.isInRequest.value
                              ? const LoadingDialog()
                              : Column(
                                  children: state.productList!
                                      .map(
                                        (e) => buildShopItem(
                                          isSelected: state.currentProduct.value == e,
                                          title: 'freeTrial'.tr,
                                          amount: e.productDetails?.price ?? '',
                                          onTap: () => controller.selectProduct(e),
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
                    child: NormalButton(
                      text: 'subscribe'.tr,
                      textColor: UIColor.white,
                      bgColor: UIColor.primary,
                      onTap: () => controller.subscribe(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'subscribeTips'.tr,
                      style: TextStyle(
                        color: UIColor.cBDBDBD,
                        fontSize: 12,
                        fontWeight: FontWeightExt.medium,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTextBtn(
                          'restore'.tr,
                          () => controller.restore(),
                        ),
                        buildLine(),
                        buildTextBtn(
                          'termsOfUse'.tr,
                          () => controller.skipUrl(false),
                        ),
                        buildLine(),
                        buildTextBtn(
                          'privacyPolicy'.tr,
                          () => controller.skipUrl(true),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildTextBtn(String text, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: UIColor.cBDBDBD,
          fontSize: 10,
          fontWeight: FontWeightExt.medium,
          decoration: TextDecoration.underline,
          decorationColor: UIColor.cBDBDBD,
        ),
      ),
    );
  }

  Container buildLine() {
    return Container(
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: UIColor.transparent40,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5, color: UIColor.cBDBDBD),
          borderRadius: BorderRadius.circular(0.5),
        ),
      ),
    );
  }

  Row buildRow(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon, height: 24),
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
    required String title,
    required String amount,
    required Function()? onTap,
  }) {
    Color borderColor;
    Color titleColor;
    Color amountColor;
    String rightIcon;
    Widget? selectedTag;
    if (isSelected) {
      borderColor = UIColor.c40BD95;
      titleColor = UIColor.cD8FE5C;
      amountColor = UIColor.white;
      rightIcon = 'images/icon/check_circle.png';
      selectedTag = Container(
        height: 22,
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: ShapeDecoration(
          color: UIColor.transparent40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'autoRenewable'.tr,
          style: const TextStyle(
            color: UIColor.c00997A,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      borderColor = UIColor.cE5E5E5;
      titleColor = UIColor.c8E8B8B;
      amountColor = UIColor.c15221D;
      rightIcon = 'images/icon/unchecked_circle.png';
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        amount,
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (selectedTag != null) selectedTag,
                    ],
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
