// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:plant/api/request.dart';
// import 'package:plant/controllers/user_controller.dart';
// import 'package:plant/models/shop_model.dart';

// import 'firebase_util.dart';

// class BuyShop {
//   late InAppPurchase _inAppPurchase;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;

//   String? orderNum;

//   void onClose() {
//     _subscription.cancel();
//   }

//   void initializeInAppPurchase() {
//     _inAppPurchase = InAppPurchase.instance;

//     //监听购买的事件
//     final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       error.printError();
//       Fluttertoast.showToast(msg: 'paymentInitiationFailure'.tr);
//     });
//   }

//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
//     for (final purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         print("等待支付");
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           if (Get.isDialogOpen ?? false) {
//             Get.back();
//           }
//           Fluttertoast.showToast(msg: purchaseDetails.error?.message ?? 'pay error');
//         } else if (purchaseDetails.status == PurchaseStatus.canceled) {
//           if (Get.isDialogOpen ?? false) {
//             Get.back();
//           }
//           Fluttertoast.showToast(msg: 'paymentHasBeenCanceled'.tr);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
//           print("监控到需要验证的订单，订单号：$orderNum");
//           if (!(Get.isDialogOpen ?? false)) {
//             Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
//           }
//           if (orderNum == null) {
//             await _appleRetryVerifyOrder(purchaseDetails);
//           } else {
//             await _verifyPurchase(purchaseDetails);
//           }
//           if (Get.isDialogOpen ?? false) {
//             Get.back();
//           }
//           Get.find<UserController>().getUserInfo();
//           Get.back();
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           print("关闭未完成的支付");
//           try {
//             await _inAppPurchase.completePurchase(purchaseDetails);
//           } catch (e) {
//             print("关闭未完成订单出错:${e.toString()}");
//           }
//         }
//       }
//     }
//   }

//   Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
//     print("开始验证支付的订单");
//     await LabRequest.appleVerifyOrder(
//       shopId: purchaseDetails.productID,
//       receipt: purchaseDetails.verificationData.serverVerificationData,
//       transactionId: purchaseDetails.purchaseID,
//       orderNum: orderNum,
//     );
//     FireBaseUtil.logEventConsumptionOrder(purchaseDetails.productID,'');
//     orderNum = null;
//     print("关闭支付的订单");
//     try {
//       await _inAppPurchase.completePurchase(purchaseDetails);
//     } catch (e) {
//       print("关闭已支付订单出错:${e.toString()}");
//     }
//   }

//   Future<void> _appleRetryVerifyOrder(PurchaseDetails purchaseDetails) async {
//     print("开始验证恢复的订单");
//     await LabRequest.appleRetryVerifyOrder(
//       shopId: purchaseDetails.productID,
//       receipt: purchaseDetails.verificationData.serverVerificationData,
//       transactionId: purchaseDetails.purchaseID,
//       orderNum: null,
//     );
//     FireBaseUtil.logEventConsumptionOrder(purchaseDetails.productID,'');
//     print("关闭恢复的订单");
//     try {
//       await _inAppPurchase.completePurchase(purchaseDetails);
//     } catch (e) {
//       print("关闭已恢复订单出错:${e.toString()}");
//     }
//   }

//   Future<void> resumePurchase() async {
//     Get.dialog(const Center(child: CircularProgressIndicator()));
//     try {
//       await _inAppPurchase.restorePurchases();
//       // Get.back();
//     } catch (e) {
//       if (Get.isDialogOpen ?? false) {
//         Get.back();
//       }
//       Fluttertoast.showToast(msg: 'restoreTips'.tr);
//       // Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
//     }
//   }

//   void submit(ShopModel? currentItem, bool buyNonConsumable) async {
//     if (currentItem == null) {
//       return;
//     }
//     if (currentItem.productDetails?.id == null) {
//       return;
//     }
//     Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
//     FireBaseUtil.logEventCreateOrder(currentItem.productDetails!.id);
//     orderNum = await LabRequest.appleCreateOrder(shopID: currentItem.productDetails!.id);
//     if (orderNum == null) {
//       Get.back();
//       Fluttertoast.showToast(msg: 'orderCreationFailure'.tr);
//       return;
//     }

//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       Get.back();
//       Fluttertoast.showToast(msg: 'paymentInitiationFailure'.tr);
//       return;
//     }
//     try {
//       late PurchaseParam purchaseParam;
//       purchaseParam = PurchaseParam(productDetails: currentItem.productDetails!, applicationUserName: orderNum);
//       if (!buyNonConsumable || currentItem.isForever) {
//         await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
//       } else {
//         await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//       }
//       FireBaseUtil.logEventPayOrder(currentItem.productDetails!.id,'');
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       Get.back();
//     }
//   }

//   Future<ProductDetailsResponse> getProduct(Set<String> kIds) async {
//     return await InAppPurchase.instance.queryProductDetails(kIds);
//   }
// }
