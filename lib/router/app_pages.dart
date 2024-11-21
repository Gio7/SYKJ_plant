import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/chat_expert/chat_expert_content.dart';
import 'package:plant/pages/login/login_page.dart';
import 'package:plant/pages/my_plants/plants_chose_page.dart';
import 'package:plant/pages/reminder_edit/reminder_edit_page.dart';
import 'package:plant/pages/shop/shop_page.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.shop,
      page: () => const ShopPage(),
      fullscreenDialog: true,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: AppRoutes.reminderEdit,
      page: () => ReminderEditPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.chatExpertContent,
      page: () => const ChatExpertContent(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.plantsChose,
      page: () => const PlantsChosePage(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isLoggedIn = false;
    bool isRealVip = false;
    if (Get.isRegistered<UserController>()) {
      isLoggedIn = Get.find<UserController>().isLogin.value;
    }
    if (!isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    if (route == AppRoutes.reminderEdit || route == AppRoutes.chatExpertContent) {
      isRealVip = Get.find<UserController>().userInfo.value.isRealVip;
      if (!isRealVip) {
        return const RouteSettings(name: AppRoutes.shop);
      }
    }
    return null;
  }
}
