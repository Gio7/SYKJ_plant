import 'package:get/get.dart';

class ShopState {
  List<dynamic>? productList;
  Rx<dynamic> currentProduct = Rx<dynamic>(null);
  RxBool isInRequest = true.obs;

  ShopState() {
    productList = [
      {
        'title': '3-day free trial',
        'amount': '\$ 39.99/year',
      },
      {
        'title': 'Best value',
        'amount': '\$ 139.99/year',
      },
    ];
    currentProduct.value = productList!.first;
    isInRequest.value = false;
  }
}
