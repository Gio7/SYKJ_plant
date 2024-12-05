import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:plant/api/request.dart';
import 'package:plant/controllers/user_controller.dart';

import 'des_util.dart';
import 'firebase_util.dart';
import 'rsa.dart';

class BuyEngine {
  static final BuyEngine _instance = BuyEngine._internal();

  BuyEngine._internal();

  factory BuyEngine() {
    return _instance;
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late Stream<List<PurchaseDetails>> _purchaseStream;
  late StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isRestored = false;

  String? sign;

  String? orderNum;

  Future<void> initialize() async {
    _purchaseStream = _inAppPurchase.purchaseStream;
    _subscription = _purchaseStream.listen((purchaseDetailsList) {
      Get.log('检测到需要处理的订单数：${purchaseDetailsList.length}');
      if (_isRestored) {
        _isRestored = false;
        if (purchaseDetailsList.isEmpty) {
          _disposeDialog();
          Fluttertoast.showToast(msg: 'restoreTips'.tr);
          return;
        }
        _handlePurchaseUpdates(purchaseDetailsList, isRestored: true);
      } else {
        _handlePurchaseUpdates(purchaseDetailsList);
      }
    }, onDone: () {
      _subscription?.cancel();
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

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _checkPaySuccess() async {
    await Get.find<UserController>().getUserInfo();
    Get.back(closeOverlays: Get.currentRoute != '/');
    dispose();
  }

  void _openDialog() {
    if (Get.isDialogOpen != true) {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    }
  }

  void _disposeDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList, {bool isRestored = false}) async {
    if (isRestored) {
      Get.log("恢复订单,批量处理:${purchaseDetailsList.length}个");
      await _checkPayInfo(purchaseDetailsList.last, isRestored: true);
      await _checkPaySuccess();
      return;
    }
    Get.log("处理订单,待处理:${purchaseDetailsList.length}个");
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        Get.log("等待支付");
      } else {
        if (purchase.status == PurchaseStatus.error) {
          _disposeDialog();
          Get.log("支付出错:${purchase.error?.toString()}");
          Fluttertoast.showToast(
            msg: purchase.error?.message ?? 'pay error',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            gravity: ToastGravity.CENTER,
          );
        } else if (purchase.status == PurchaseStatus.canceled) {
          _disposeDialog();
          Fluttertoast.showToast(msg: 'paymentHasBeenCanceled'.tr);
        } else if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
          Get.log("监控到需要验证的订单，订单号：$orderNum");
          await _checkPayInfo(purchase);
          await _inAppPurchase.completePurchase(purchase);
          FireBaseUtil.subscribeSuccess(purchase.productID);
          await _checkPaySuccess();
        }
        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
      }
    }
  }

  /// 发起购买
  Future<void> buyProduct(ProductDetails? product, bool buyNonConsumable) async {
    FireBaseUtil.subscribeCreate(product?.id);
    if (product?.id == null) {
      return;
    }
    _openDialog();
    final res = await Request.createOrder(product!.id);
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
        productDetails: product,
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

  Future<void> restoredPurchase() async {
    _openDialog();
    try {
      _isRestored = true;
      await _inAppPurchase.restorePurchases();
      // Get.back();
    } catch (e) {
      _isRestored = false;
      _disposeDialog();
      Fluttertoast.showToast(msg: 'restoreTips'.tr);
    }
  }

  Future<void> _checkPayInfo(PurchaseDetails purchaseDetails, {bool isRestored = false}) async {
    _openDialog();
    if (isRestored == false) {
      FireBaseUtil.logEvent(EventName.memberPurchaseSuccess);
    }
    sign ??= await Request.getOrderKey();
    final desKey = await Rsa.decodeString(sign);
    final Map data = {
      'orderNum': orderNum ?? '',
      'productId': purchaseDetails.productID,
      'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
      'payOrderId': purchaseDetails.purchaseID,
      'type': isRestored ? 1 : 0,
    };
    final jsonString = jsonEncode(data);
    final time = DateTime.now().millisecondsSinceEpoch;
    final dataString = DesUtil.desEncrypt(jsonString, desKey, time);
    Get.log("开始验证支付的订单");
    final res = await Request.verifyOrder(dataString, time);
    orderNum = null;
    if (res?['code'] == 204 && isRestored == false) {
      restoredPurchase();
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
