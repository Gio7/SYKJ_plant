import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/components/custom_bottom_nav_bar.dart';
import 'package:plant/components/page_bg.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/my_plants/my_plants_page.dart';

import 'home_page.dart';
import 'shoot_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  MainController mainController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    mainController.tabController = TabController(length: 3, vsync: this);
    super.initState();
    userController.getUserInfo();
    // WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) => getAdID());
    // WidgetsBinding.instance.addPostFrameCallback((_) => getAdID());
  }

  @override
  void dispose() {
    mainController.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: Scaffold(
        backgroundColor: UIColor.transparent,
        body: SafeArea(
          top: true,
          child: TabBarView(
            controller: mainController.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomePage(),
              SizedBox(),
              MyPlantsPage(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: mainController.tabController.index,
          onTap: (index) {
            HapticFeedback.lightImpact();
            if (index == 1) {
              return;
            }
            setState(() {
              mainController.tabController.index = index;
            });
          },
          centerOnTap: () {
            HapticFeedback.lightImpact();
            FireBaseUtil.logEvent(EventName.homeShootBttom);
            Get.to(() => const ShootPage());
          },
        ),
      ),
    );
  }
}
