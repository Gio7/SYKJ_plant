import 'package:get/get.dart';

import 'main_controller.dart';
import 'user_controller.dart';

class CoreBindingController implements Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController(),permanent: true);
    Get.put<MainController>(MainController(),permanent: true);
    // Get.lazyPut<MainController>(() => MainController(), fenix: true);
  }
}
