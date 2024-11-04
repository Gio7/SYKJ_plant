import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/widgets/custom_segmented.dart';
import '../../widgets/user_nav_bar.dart';
import 'my_plants_controller.dart';
import 'plants_page.dart';
import 'reminders_page.dart';

class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyPlantsController());
    final repository = Get.find<MyPlantsController>().repository;
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserNavBar(needUser: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: CustomSegmented(
                data: repository.customSegmentedValues,
                selected: repository.currentTab.value,
                onChange: (e) => controller.onSegmentChange(e),
              ),
            ),
            repository.currentTab.value.value == '1' ? PlantsPage() : RemindersPage(),
          ],
        ));
  }
}
