import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/btn.dart';

import 'shoot_page.dart';
import '../controllers/user_nav_bar.dart';

class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UserNavBar(needUser: true),
        Container(
          margin: const EdgeInsets.only(left: 24, top: 16),
          child: Text(
            'myPlants'.tr,
            style: const TextStyle(
              color: UIColor.c15221D,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: DottedDecoration(shape: Shape.box, color: UIColor.cAEE9CD, strokeWidth: 1, dash: const <int>[2, 2], borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/icon/plants.png', height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'youHaveNoPlants'.tr,
                  style: const TextStyle(
                    color: UIColor.c15221D,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              NormalButton(
                onTap: () {
                  Get.to(() => const ShootPage());
                },
                bgColor: UIColor.transparentPrimary40,
                text: 'addPlant'.tr,
                textColor: UIColor.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
