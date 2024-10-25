import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.currentIndex, this.onTap, this.centerOnTap});
  final int currentIndex;
  final Function(int)? onTap;
  final Function()? centerOnTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78 + Get.mediaQuery.padding.bottom,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            height: 64 + Get.mediaQuery.padding.bottom,
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                enableFeedback: true,
                onTap: onTap,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                backgroundColor: UIColor.white,
                selectedItemColor: UIColor.primary,
                unselectedItemColor: UIColor.cBDBDBD,
                elevation: 0,
                iconSize: 28,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: 'home'.tr,
                    icon: Image.asset(
                      'images/tabbar/home.png',
                      width: 28,
                      height: 28,
                    ),
                    activeIcon: Image.asset(
                      'images/tabbar/home_selected.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: 'diagnose'.tr,
                    icon: Image.asset(
                      'images/tabbar/diagnose.png',
                      width: 28,
                      height: 28,
                    ),
                    activeIcon: Image.asset(
                      'images/tabbar/diagnose_selected.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  const BottomNavigationBarItem(icon: SizedBox(), label: ''),
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: "myPlants".tr,
                    icon: Image.asset(
                      'images/tabbar/my_plant.png',
                      width: 28,
                      height: 28,
                    ),
                    activeIcon: Image.asset(
                      'images/tabbar/my_plant_selected.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: "profile".tr,
                    icon: Image.asset(
                      'images/tabbar/user.png',
                      width: 28,
                      height: 28,
                    ),
                    activeIcon: Image.asset(
                      'images/tabbar/user_selected.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0, left: Get.width / 2 - 35),
            color: UIColor.transparent,
            child: GestureDetector(
              onTap: centerOnTap,
              child: Image.asset('images/icon/bottom_camera.png', width: 70),
            ),
          ),
        ],
      ),
    );
  }
}
