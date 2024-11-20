part of './shop_controller.dart';

class ShopState {
  List<MemberProductModel>? productList;
  Rxn<MemberProductModel> currentProduct = Rxn<MemberProductModel>();

  /// 是否正在请求数据
  late RxBool isInRequest;

  RxString priceIntroductionText = ''.obs;
  RxString historyVipTips2 = "historyVipTips2".tr.obs;

  ShopState() {
    isInRequest = true.obs;
  }
}
