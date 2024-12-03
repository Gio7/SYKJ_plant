import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:plant/pages/chat_expert/chat_expert_page.dart';
import 'package:plant/pages/diagnose_home/diagnose_home_page.dart';
import 'package:plant/pages/shop/shop_page.dart';
import 'package:plant/router/app_pages.dart';
import 'package:plant/widgets/custom_bottom_nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';
import 'package:plant/controllers/main_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/my_plants/my_plants_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home_page.dart';
import 'plant_scan/shoot_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  MainController mainController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    mainController.tabController = TabController(length: 5, vsync: this)..addListener(() => setState(() {}));
    super.initState();
    userController.getUserInfo().then((v) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkOpenCount());
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    mainController.tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      userController.getUserInfo();
    }
  }

  void _checkOpenCount() {
    // 非会员每天前两次启动APP打开弹窗
    final userCtr = Get.find<UserController>();
    if (userCtr.isLogin.value && !userCtr.userInfo.value.isRealVip) {
      SharedPreferences.getInstance().then((prefs) {
        final timeNow = DateTime.now();
        final today = DateTime(timeNow.year, timeNow.month, timeNow.day).millisecondsSinceEpoch;
        int lastOpenTime = prefs.getInt('lastOpenTime') ?? 0;
        int openCount = prefs.getInt('openCount') ?? 0;

        if (lastOpenTime == today) {
          openCount += 1;
        } else {
          openCount = 1;
        }

        if (openCount <= 2) {
          _showShopDialog(userCtr);
        }

        prefs.setInt('openCount', openCount);
        prefs.setInt('lastOpenTime', today);
      });
    }
  }

  void _showShopDialog(UserController userCtr) {
    if (userCtr.userInfo.value.memberType == MemberType.normal) {
      Get.to(
        () => const ShopPage(
          formPage: ShopFormPage.main,
        ),
        fullscreenDialog: true,
      );
      FireBaseUtil.logEvent(EventName.openAppFreePage);
    } else {
      Get.toNamed(AppRoutes.shop);
      FireBaseUtil.membershipPageEvent('main');
    }
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
              ChatExpertPage(),
              MyPlantsPage(),
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

            if (index == 3) {
              FireBaseUtil.logEvent(EventName.gptPage);
            }
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
