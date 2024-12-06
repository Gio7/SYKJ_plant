import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/buy_engine.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/global_data.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/member_product_model.dart';
import 'package:plant/models/userinfo_model.dart';
import 'package:plant/pages/identify_history/identify_history_controller.dart';
import 'package:url_launcher/url_launcher.dart';
//import for AppStoreProductDetails
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
//import for SKProductWrapper
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
//import for GooglePlayProductDetails
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//import for SkuDetailsWrapper
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';

import 'shop_page.dart';

part 'shop_state.dart';

class ShopController extends GetxController {
  final ShopFormPage formPage;

  ShopController(this.formPage);

  final ShopState state = ShopState();

  late BuyEngine _buyEngine;

  @override
  onInit() {
    super.onInit();

    _buyEngine = BuyEngine();
    _buyEngine.initialize();
    getShopData();
  }

  Future<void> getShopData() async {
    await getShopList();
    if (formPage == ShopFormPage.identify || formPage == ShopFormPage.main || formPage == ShopFormPage.history) {
      state.currentProduct.value = state.productList?.firstWhereOrNull((e) => e.memberType == 3);

      if (state.currentProduct.value != null) {
        String text = "startYourFreeTrial".tr;
        if (formPage == ShopFormPage.history) {
          if (Get.find<UserController>().userInfo.value.memberType != MemberType.normal) {
            text = "onlyCancelAnytime".tr;
          }

          final count = Get.find<IdentifyHistoryController>().repository.total;
          String historyVipTips2 = "historyVipTips2".tr;
          historyVipTips2 = historyVipTips2.replaceFirst('0', '$count');
          state.historyVipTips2.value = historyVipTips2;
        }
        text = text.replaceFirst('999', '${state.currentProduct.value!.productDetails?.price}');
        state.priceIntroductionText.value = text;
      } else {
        Get.back(closeOverlays: true);
      }
    }
  }

  Future<void> skipUrl(bool isPrivacy) async {
    try {
      final url = Uri.parse(isPrivacy ? GlobalData.privacyNoticeUrl : GlobalData.termsOfUseUrl);
      final bool isSul = await launchUrl(
        url,
      );
      if (!isSul) {
        Fluttertoast.showToast(
          msg: 'error fail',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'error ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void selectProduct(dynamic product) {
    state.currentProduct.value = product;
  }

  Future<void> restore() async {
    FireBaseUtil.logEvent(EventName.subscribeRestore);
    _buyEngine.restoredPurchase();
  }

  Future<void> subscribe() async {
    if (state.currentProduct.value == null) return;
    if (formPage == ShopFormPage.main) {
      FireBaseUtil.logEvent(EventName.openAppFreePageBtn);
    } else if (formPage == ShopFormPage.identify) {
      FireBaseUtil.logEvent(EventName.resultCloseFreePageBtn);
    } else if (formPage == ShopFormPage.history) {
      FireBaseUtil.logEvent(EventName.savePagePurchaseBtn);
    } else {
      FireBaseUtil.logEvent(EventName.memberPurchaseSelect);
    }
    ProductDetails? product = state.currentProduct.value?.productDetails;
    if (state.currentProduct.value?.freeProductDetails != null) {
      product = state.currentProduct.value!.freeProductDetails;
    }
    _buyEngine.buyProduct(product, true);
  }

  Future<void> getShopList() async {
    final res = await Request.getShopList('0');

    try {
      final memberType = Get.find<UserController>().userInfo.value.memberType;
      final resList = res.map((e) => MemberProductModel.fromJson(e)).toList();
      resList.removeWhere((e) => e.shopId == null);
      final Set<String> ids = resList.map((e) => e.shopId!).toSet();
      ProductDetailsResponse? pdRes;
      if (ids.isNotEmpty) {
        pdRes = await _buyEngine.getProduct(ids);
      }
      if (pdRes != null && pdRes.productDetails.isNotEmpty) {
        for (final apiShop in resList) {
          apiShop.productDetails = pdRes.productDetails.firstWhereOrNull((element) => apiShop.shopId == element.id && element.rawPrice != 0);
          if (apiShop.productDetails is AppStoreProductDetails) {
            SKProductWrapper skProduct = (apiShop.productDetails as AppStoreProductDetails).skProduct;
            // 判断Apple商品是否有试用
            if (skProduct.introductoryPrice != null && memberType == MemberType.normal) {
              apiShop.freeProductDetails = apiShop.productDetails;
            }
          } else if (apiShop.productDetails is GooglePlayProductDetails) {
            // ProductDetailsWrapper skuDetails = (apiShop.productDetails as GooglePlayProductDetails).productDetails;
            // 获取Google商品是否有试用
            apiShop.freeProductDetails = pdRes.productDetails.firstWhereOrNull((element) => apiShop.shopId == element.id && element.rawPrice == 0);
          }
        }
      }
      resList.removeWhere((e) => e.productDetails == null);
      state.productList = resList;
      if (state.productList == null || state.productList!.isEmpty) {
        state.isInRequest.value = false;
        Fluttertoast.showToast(
          msg: 'productNotFound'.tr,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.CENTER,
        );
        return;
      }

      state.currentProduct.value = resList.firstWhereOrNull((e) => (e.selected ?? false)) ?? resList.first;
      state.isInRequest.value = false;
    } catch (e) {
      state.isInRequest.value = false;
      Fluttertoast.showToast(
        msg: 'productNotFound'.tr,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.CENTER,
      );
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }
}
