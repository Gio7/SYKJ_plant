// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:plant/api/request.dart';
import 'package:plant/controllers/user_controller.dart';

import 'firebase_util.dart';

class BuyShop {
  late InAppPurchase _inAppPurchase;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  String? orderNum;

  void onClose() {
    _subscription.cancel();
  }

  void initializeInAppPurchase() {
    _inAppPurchase = InAppPurchase.instance;

    //监听购买的事件
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      error.printError();
      Fluttertoast.showToast(msg: 'paymentInitiationFailure'.tr);
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        Get.log("等待支付");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          Fluttertoast.showToast(msg: purchaseDetails.error?.message ?? 'pay error');
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          Fluttertoast.showToast(msg: 'paymentHasBeenCanceled'.tr);
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          Get.log("监控到需要验证的订单，订单号：$orderNum");
          if (!(Get.isDialogOpen ?? false)) {
            Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
          }
          await _checkPayInfo(purchaseDetails);
          await Get.find<UserController>().getUserInfo();
          Get.back(closeOverlays: Get.currentRoute != '/');
        }
        if (purchaseDetails.pendingCompletePurchase) {
          Get.log("关闭未完成的支付");
          try {
            await _inAppPurchase.completePurchase(purchaseDetails);
          } catch (e) {
            Get.log("关闭未完成订单出错:${e.toString()}");
          }
        }
      }
    }
  }

  Future<void> _checkPayInfo(PurchaseDetails purchaseDetails) async {
    if (orderNum == null) {
      await _appleRetryVerifyOrder(purchaseDetails);
    } else {
      await _verifyPurchase(purchaseDetails);
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    Get.log("开始验证支付的订单");
    // await Request.appleVerifyOrder(
    //   shopId: purchaseDetails.productID,
    //   receipt: purchaseDetails.verificationData.serverVerificationData,
    //   transactionId: purchaseDetails.purchaseID,
    //   orderNum: orderNum,
    // );
    FireBaseUtil.logEventConsumptionOrder(purchaseDetails.productID, '');
    orderNum = null;
    Get.log("关闭支付的订单");
    try {
      await _inAppPurchase.completePurchase(purchaseDetails);
    } catch (e) {
      Get.log("关闭已支付订单出错:${e.toString()}");
    }
  }

  Future<void> _appleRetryVerifyOrder(PurchaseDetails purchaseDetails) async {
    Get.log("开始验证恢复的订单");
    // await Request.appleRetryVerifyOrder(
    //   shopId: purchaseDetails.productID,
    //   receipt: purchaseDetails.verificationData.serverVerificationData,
    //   transactionId: purchaseDetails.purchaseID,
    //   orderNum: null,
    // );
    FireBaseUtil.logEventConsumptionOrder(purchaseDetails.productID, '');
    Get.log("关闭恢复的订单");
    try {
      await _inAppPurchase.completePurchase(purchaseDetails);
    } catch (e) {
      Get.log("关闭已恢复订单出错:${e.toString()}");
    }
  }

  Future<void> resumePurchase() async {
    Get.dialog(const Center(child: CircularProgressIndicator()));
    try {
      await _inAppPurchase.restorePurchases();
      // Get.back();
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Fluttertoast.showToast(msg: 'restoreTips'.tr);
      // Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }

  /* void submit(ShopModel? currentItem, bool buyNonConsumable) async {
    if (currentItem == null) {
      return;
    }
    if (currentItem.productDetails?.id == null) {
      return;
    }
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    FireBaseUtil.logEventCreateOrder(currentItem.productDetails!.id);
    orderNum = await Request.appleCreateOrder(shopID: currentItem.productDetails!.id);
    if (orderNum == null) {
      Get.back();
      Fluttertoast.showToast(msg: 'orderCreationFailure'.tr);
      return;
    }

    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      Get.back();
      Fluttertoast.showToast(msg: 'paymentInitiationFailure'.tr);
      return;
    }
    try {
      late PurchaseParam purchaseParam;
      purchaseParam = PurchaseParam(productDetails: currentItem.productDetails!, applicationUserName: orderNum);
      if (!buyNonConsumable || currentItem.isForever) {
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
      FireBaseUtil.logEventPayOrder(currentItem.productDetails!.id,'');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Get.back();
    }
  } */

  Future<ProductDetailsResponse> getProduct(Set<String> kIds) async {
    try {
      return await InAppPurchase.instance.queryProductDetails(kIds);
    } catch (e) {
      rethrow;
    }
  }
}
