import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/my_plants_page.dart';

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
    userController.getVersion();
    userController.getUserInfo();
  }

  @override
  void dispose() {
    mainController.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0, 0.28],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [UIColor.cD9F0E5, UIColor.cF3F4F3],
        ),
      ),
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
        bottomNavigationBar: StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            disableDefaultTabController: false,
            initialActiveIndex: 0,
            height: 64,
            top: -15,
            curveSize: 64,
            style: TabStyle.fixedCircle,
            backgroundColor: UIColor.white,
            shadowColor: UIColor.transparent,
            color: UIColor.cBDBDBD,
            activeColor: UIColor.primary,
            items: [
              TabItem(
                title: 'home'.tr,
                icon: Image.asset(
                  'images/tabbar/home.png',
                  width: 24,
                  height: 24,
                ),
                activeIcon: Image.asset(
                  'images/tabbar/home_selected.png',
                  width: 24,
                  height: 24,
                ),
              ),
              TabItem(
                icon: Container(
                  // padding: const EdgeInsets.only(bottom: 3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [UIColor.c40BD95, UIColor.cAEE9CD],
                    ),
                  ),
                  child: Center(
                    child: Image.asset('images/icon/camera.png', width: 32),
                  ),
                ),
              ),
              TabItem(
                title: "myPlants".tr,
                icon: Image.asset(
                  'images/tabbar/my_plant.png',
                  width: 24,
                  height: 24,
                ),
                activeIcon: Image.asset(
                  'images/tabbar/my_plant_selected.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
            onTabNotify: (i) {
              var intercept = i == 1;
              if (intercept) {
                Get.to(() => const ShootPage());
              }
              return !intercept;
            },
            onTap: (i) {
              mainController.tabController.index = i;
            },
          ),
        ),
      ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 24;

  @override
  double get activeIconMargin => 14;

  @override
  double get iconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 9, color: color, fontFamily: fontFamily);
  }
}
