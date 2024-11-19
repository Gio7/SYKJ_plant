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
          leftWidget: IconButton(
            onPressed: () => Get.back(),
            icon: const ImageIcon(
              AssetImage('images/icon/close.png'),
              size: 32,
              color: UIColor.c15221D,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: formPage == ShopFormPage.diagnose
                ? const ShopFromDiagnose()
                : formPage == ShopFormPage.history
                    ? const ShopFromHistory()
                    : formPage == ShopFormPage.main
                        ? const ShopFromMain()
                        : ShopNormal(controller: controller),
          ),
        ),
      ),
    );
  }
}
