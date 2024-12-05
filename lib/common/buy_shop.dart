// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:plant/api/request.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/member_product_model.dart';

import 'des_util.dart';
import 'firebase_util.dart';
import 'rsa.dart';

class BuyShopBackup {
  late InAppPurchase _inAppPurchase;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  String? orderNum;
  String? sign;

  bool _isResume = false;

  void onClose() {
    _subscription.cancel();
  }

  void initializeInAppPurchase() {
    _inAppPurchase = InAppPurchase.instance;

    //监听购买的事件
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      Get.log('检测到需要处理的订单数：${purchaseDetailsList.length}');
      final List<PurchaseDetails> restoredList = purchaseDetailsList.where((e) => e.status == PurchaseStatus.restored).toList();
      final List<PurchaseDetails> otherList = purchaseDetailsList.where((e) => e.status != PurchaseStatus.restored).toList();
      if (_isResume) {
        _isResume = false;
        if (otherList.isEmpty) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          Fluttertoast.showToast(msg: 'restoreTips'.tr);
        }
      }
      _listenToPurchaseUpdated(restoredList, otherList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      error.printError();
      Fluttertoast.showToast(
        msg: 'paymentInitiationFailure'.tr,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> restoredList, List<PurchaseDetails> otherList) async {
    if (restoredList.isNotEmpty) {
      Get.log("恢复订单,批量处理:${restoredList.length}个");
      if (!(Get.isDialogOpen ?? false)) {
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      }
      sign ??= await Request.getOrderKey();

      await _checkPayInfo(restoredList.last);

      await Get.find<UserController>().getUserInfo();
      Get.back(closeOverlays: Get.currentRoute != '/');
      for (final purchaseDetails in restoredList) {
        try {
          Get.log("关闭恢复订单");
          _inAppPurchase.completePurchase(purchaseDetails);
        } catch (e) {
          Get.log("关闭恢复订单出错:${e.toString()}");
        }
      }
    }
    Get.log("处理订单,待处理:${otherList.length}个");
    for (final purchaseDetails in otherList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        Get.log("等待支付");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          Get.log("支付出错:${purchaseDetails.error?.toString()}");
          Fluttertoast.showToast(
            msg: purchaseDetails.error?.message ?? 'pay error',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.CENTER,
          );
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
          sign ??= await Request.getOrderKey();
          await _checkPayInfo(purchaseDetails);
          FireBaseUtil.subscribeSuccess(purchaseDetails.productID);
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
    if (sign == null) {
      return;
    }
    final desKey = await Rsa.decodeString(sign);
    Map data = {
      'orderNum': orderNum ?? '',
      'productId': purchaseDetails.productID,
      'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
      'payOrderId': purchaseDetails.purchaseID,
      'type': orderNum == null ? 1 : 0,
    };
    final jsonString = jsonEncode(data);
    final time = DateTime.now().millisecondsSinceEpoch;
    final dataString = DesUtil.desEncrypt(jsonString, desKey, time);
    Get.log("开始验证支付的订单");
    final res = await Request.verifyOrder(dataString, time);
    if (res?['code'] == 204 && orderNum != null) {
      orderNum = null;
      resumePurchase();
    } else {
      orderNum = null;
      FireBaseUtil.logEvent(EventName.memberPurchaseSuccess);
      Get.log("关闭支付的订单");
      try {
        await _inAppPurchase.completePurchase(purchaseDetails);
      } catch (e) {
        Get.log("关闭已支付订单出错:${e.toString()}");
      }
    }
  }

  Future<void> resumePurchase() async {
    Get.dialog(const Center(child: CircularProgressIndicator()));
    try {
      _isResume = true;
      await _inAppPurchase.restorePurchases();
      // Get.back();
    } catch (e) {
      _isResume = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Fluttertoast.showToast(msg: 'restoreTips'.tr);
    }
  }

  void submit(MemberProductModel currentItem, bool buyNonConsumable) async {
    FireBaseUtil.subscribeCreate(currentItem.productDetails?.id);
    if (currentItem.productDetails?.id == null) {
      return;
    }
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    final res = await Request.createOrder(currentItem.productDetails!.id);
    orderNum = res['orderNum'];
    sign = res['sign'];

    if (orderNum == null || sign == null) {
      Get.back();
      Fluttertoast.showToast(
        msg: 'orderCreationFailure'.tr,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      Get.back();
      Fluttertoast.showToast(
        msg: 'paymentInitiationFailure'.tr,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    try {
      final uid = Get.find<UserController>().userInfo.value.userid;
      if (uid == null) {
        throw Exception('uid is null');
      }
      //obfuscatedExternalProfileId == orderNum
      // obfuscatedExternalAccountId == uidGet.find<UserController>().getUserInfo();
      final applicationUserName = '$orderNum,$uid';
      // Get.log('applicationUserName: $applicationUserName');
      final purchaseParam = PurchaseParam(
        productDetails: currentItem.productDetails!,
        applicationUserName: applicationUserName,
      );
      if (buyNonConsumable) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.CENTER,
      );
      Get.back();
    }
  }

  Future<ProductDetailsResponse> getProduct(Set<String> kIds) async {
    try {
      return await InAppPurchase.instance.queryProductDetails(kIds);
    } catch (e) {
      rethrow;
    }
  }
}
