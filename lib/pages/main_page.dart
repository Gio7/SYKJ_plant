import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/my_plants_page.dart';

import 'home_page.dart';
import 'shoot_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    UserController userController = Get.find();
    userController.getVersion();
    userController.getUserInfo();
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              SizedBox(),
              MyPlantsPage(),
            ],
          ),
          bottomNavigationBar: StyleProvider(
            style: Style(),
            child: ConvexAppBar(
              disableDefaultTabController: true,
              initialActiveIndex: 0,
              height: 50,
              top: -30,
              curveSize: 100,
              style: TabStyle.fixedCircle,
              items: [
                const TabItem(title: '2019', icon: Icons.link),
                TabItem(
                  icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF5722),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 56),
                  ),
                ),
                const TabItem(title: "2020", icon: Icons.work),
              ],
              backgroundColor: UIColor.white,
              shadowColor: UIColor.transparent,
              onTabNotify: (i) {
                var intercept = i == 1;
                if (intercept) {
                  // Navigator.pushNamed(context, '/fab');
                  Get.to(() => const ShootPage());
                }
                return !intercept;
              },
              onTap: (i) => debugPrint('click $i'),
            ),
          ),
        ));
  }

  GridView paletteBody() {
    return GridView.count(
      crossAxisCount: 5,
      childAspectRatio: 1,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: [const Text('data')],
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 20, color: color, fontFamily: fontFamily);
  }
}
