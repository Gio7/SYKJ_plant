import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt tabCurrentIndex = 1.obs;
  void setTabCurrentIndex(int index) {
    tabCurrentIndex.value = index;
  }
}
