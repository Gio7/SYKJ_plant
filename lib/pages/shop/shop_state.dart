part of './shop_controller.dart';

class ShopState {
  List<MemberProductModel>? productList;
  late Rx<MemberProductModel> currentProduct;

  /// 是否正在请求数据
  late RxBool isInRequest;

  ShopState() {
    currentProduct = MemberProductModel().obs;
    isInRequest = true.obs;
  }
}
