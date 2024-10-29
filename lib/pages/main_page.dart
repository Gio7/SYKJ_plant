import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/pages/diagnose_home/diagnose_home_page.dart';
import 'package:plant/pages/set/set_page.dart';
import 'package:plant/widgets/custom_bottom_nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/my_plants/my_plants_page.dart';

import 'home/home_page.dart';
import 'plant_scan/shoot_page.dart';

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
    mainController.tabController = TabController(length: 5, vsync: this)..addListener(() => setState(() {}));
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
              DiagnosePage(),
              SizedBox(),
              MyPlantsPage(),
              SetPage(hasNavBar: false)
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: mainController.tabController.index,
          onTap: (index) {
            HapticFeedback.lightImpact();
            if (index == 2) {
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
