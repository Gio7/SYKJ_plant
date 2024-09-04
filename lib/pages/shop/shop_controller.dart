import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/models/member_product_model.dart';
import 'package:url_launcher/url_launcher.dart';

part 'shop_state.dart';

class ShopController extends GetxController {
  final ShopState state = ShopState();

  Future<void> skipUrl(bool isPrivacy) async {
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
    state.currentProduct.value = product;
  }

  Future<void> restore() async {
    GlobalData.buyShop.resumePurchase();
  }

  Future<void> subscribe() async {
    // TODO 订阅
  }

  Future<void> getShopList() async {
    final res = await Request.getShopList('0');

    try {
      final resList = res.map((e) => MemberProductModel.fromJson(e)).toList();
      resList.removeWhere((e) => e.shopId == null);
      final Set<String> ids = resList.map((e) => e.shopId!).toSet();
      ProductDetailsResponse? pdRes;
      if (ids.isNotEmpty) {
        pdRes = await GlobalData.buyShop.getProduct(ids);
      }
      if (pdRes != null && pdRes.productDetails.isNotEmpty) {
        for (final apiShop in resList) {
          apiShop.productDetails = pdRes.productDetails.firstWhereOrNull((element) => apiShop.shopId == element.id);
        }
      }
      resList.removeWhere((e) => e.productDetails == null);
      state.productList = resList;
      if (state.productList == null || state.productList!.isEmpty) {
        state.isInRequest.value = false;
        Fluttertoast.showToast(msg: 'productNotFound'.tr);
        return;
      }

      state.currentProduct.value = resList.firstWhereOrNull((e) => (e.selected ?? false)) ?? resList.first;
      state.isInRequest.value = false;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
