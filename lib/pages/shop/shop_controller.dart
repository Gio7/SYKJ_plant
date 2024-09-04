import 'package:get/get.dart';
import 'package:plant/common/global_data.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shop_repository.dart';

class ShopController extends GetxController {
  final ShopRepository repository = ShopRepository();

  Future<void> skipUrl(bool isPrivacy) async{
    try {
      final url = Uri.parse(isPrivacy ? GlobalData.privacyNoticeUrl : GlobalData.termsOfUseUrl);
      final bool isSul = await launchUrl(
        url,
      );
      if (!isSul) {
        Get.snackbar('error', 'fail');
      }
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }

  void selectProduct(dynamic product) {
    repository.currentProduct.value = product;
  }

  Future<void> restore() async{
    // TODO 恢复订单
  }

  Future<void> subscribe() async {
    // TODO 订阅
  }
}
