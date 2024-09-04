import 'package:get/get.dart';

class ShopRepository {
  /**
   * 
    订阅商品ID
    7.99 week
    安卓：sub_vip_plan_weekly
    苹果：ios_sub_vip_plan_weekly
    39.99 year
    安卓：sub_vip_plan_yearly
    苹果：ios_sub_vip_plan_yearly
   */
  List<dynamic>? productList;
  Rx<dynamic> currentProduct = Rx<dynamic>(null);
  RxBool isInRequest = true.obs;

  ShopRepository() {
    productList = [
      {
        'title': '3-day free trial',
        'amount': '\$ 39.99/week',
      },
      {
        'title': '3-day free trial',
        'amount': '\$ 139.99/year',
      },
    ];
    currentProduct.value = productList!.first;
    isInRequest.value = false;
  }
}
