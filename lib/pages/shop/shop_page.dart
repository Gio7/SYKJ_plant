import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/nav_bar.dart';

import 'shop_controller.dart';
import 'widgets/shop_from_diagnose.dart';
import 'widgets/shop_from_history.dart';
import 'widgets/shop_from_main.dart';
import 'widgets/shop_normal.dart';

enum ShopFormPage {
  normal,
  history,
  diagnose,
  main,
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key, this.formPage = ShopFormPage.normal});
  final ShopFormPage formPage;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShopController());

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.28, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [UIColor.cD9F0E5, UIColor.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        appBar: NavBar(
          leftWidget: const SizedBox(),
          rightWidget: IconButton(
            onPressed: () => Get.back(),
            icon: const ImageIcon(
              AssetImage('images/icon/close.png'),
              size: 32,
              color: UIColor.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: formPage == ShopFormPage.diagnose
                      ? const ShopFromDiagnose()
                      : formPage == ShopFormPage.history
                          ? const ShopFromHistory()
                          : formPage == ShopFormPage.main
                              ? const ShopFromMain()
                              : ShopNormal(controller: controller),
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
            ),
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
          // decoration: TextDecoration.underline,
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
}
