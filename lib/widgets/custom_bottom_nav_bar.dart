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
    const home = AssetImage('images/tabbar/home.png');
    const homeSelected = AssetImage('images/tabbar/home_selected.png');
    const diagnose = AssetImage('images/tabbar/diagnose.png');
    const diagnoseSelected = AssetImage('images/tabbar/diagnose_selected.png');
    const chat = AssetImage('images/tabbar/chat.png');
    const chatSelected = AssetImage('images/tabbar/chat_selected.png');
    const myPlant = AssetImage('images/tabbar/my_plant.png');
    const myPlantSelected = AssetImage('images/tabbar/my_plant_selected.png');
    precacheImage(home, context);
    precacheImage(homeSelected, context);
    precacheImage(diagnose, context);
    precacheImage(diagnoseSelected, context);
    precacheImage(chat, context);
    precacheImage(chatSelected, context);
    precacheImage(myPlant, context);
    precacheImage(myPlantSelected, context);
    return SizedBox(
      height: 63 + Get.mediaQuery.padding.bottom, //78 + Get.mediaQuery.padding.bottom,
      child: Stack(
        clipBehavior: Clip.none,
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
                    label: 'tabHome'.tr,
                    icon: const Image(image: home, height: 28),
                    activeIcon: const Image(image: homeSelected, height: 28),
                  ),
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: 'tabDiagnose'.tr,
                    icon: const Image(image: diagnose, height: 28),
                    activeIcon: const Image(image: diagnoseSelected, height: 28),
                  ),
                  const BottomNavigationBarItem(icon: SizedBox(), label: ''),
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: "tabAskExpert".tr,
                    icon: const Image(image: chat, height: 28),
                    activeIcon: const Image(image: chatSelected, height: 28),
                  ),
                  BottomNavigationBarItem(
                    tooltip: '',
                    label: "tabMyPlants".tr,
                    icon: const Image(image: myPlant, height: 28),
                    activeIcon: const Image(image: myPlantSelected, height: 28),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 35,
            top: -15,
            child: Container(
              // margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width / 2 - 35),
              color: UIColor.transparent,
              child: GestureDetector(
                onTap: centerOnTap,
                child: Image.asset('images/icon/bottom_camera.png', width: 70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
