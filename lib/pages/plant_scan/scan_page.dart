import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/show_dialog.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/sdk/scanning_effect/scanning_effect.dart';

import '../shop/shop_view.dart';
import 'info_diagnose_page.dart';
import 'info_identify_page.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  void _requestNetwork(PlantController ctr, Completer<void> completer) async {
    if (!(Get.find<UserController>().userInfo.value.isRealVip)) {
      await Future.delayed(const Duration(milliseconds: 800));
      FireBaseUtil.subscribePageEvent(Get.currentRoute);
      await Get.to(() => ShopPage());
      if (!(Get.find<UserController>().userInfo.value.isRealVip)) {
        Get.until((route) => Get.currentRoute == '/');
        return;
      }
    }
    bool isSuccess = false;
    if (ctr.repository.shootType.value == ShootType.identify) {
      isSuccess = await ctr.requestIdentifyInfo(completer);
      if (isSuccess) {
        Get.off(() => InfoIdentifyPage());
      }
    } else {
      isSuccess = await ctr.requestDiagnoseInfo(completer);
      if (isSuccess) {
        Get.off(() => InfoDiagnosePage());
      }
    }
    if (!isSuccess && !(completer.isCompleted)) {
      Get.dialog(
        NormalDialog(
          title: 'noPlantDetected'.tr,
          subText: 'noPlantDetectedTips'.tr,
          icon: Image.asset('images/icon/plant.png', height: 70),
          confirmText: 'retakePhoto'.tr,
          cancelText: 'cancel'.tr,
          onConfirm: () {
            Get.back(closeOverlays: true);
          },
          onCancel: () {
            Get.back(closeOverlays: true);
            Get.until((route) => Get.currentRoute == '/');
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<PlantController>();
    final completer = Completer<void>();
    _requestNetwork(ctr, completer);
    completer.future.catchError((e) => Get.log(e.toString(), isError: true));

    double width = MediaQuery.of(context).size.width - 116;
    width = width > 350 ? 350 : width;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!completer.isCompleted) {
          completer.completeError('task cancel');
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/icon/scan_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'weScanForYou'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UIColor.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'scanTips'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UIColor.transparent60,
                fontSize: 14,
                fontWeight: FontWeightExt.medium,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 46),
            Container(
              width: width,
              height: width,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ScanningEffect(
                scanningColor: UIColor.primary,
                enableBorder: false,
                scanningLinePadding: EdgeInsets.zero,
                delay: Duration.zero,
                child: Image.file(
                  ctr.repository.shootType.value == ShootType.identify
                      ? ctr.repository.identifyThumbnailFile!
                      : ctr.repository.diagnoseImageFile1.value ?? ctr.repository.diagnoseImageFile2.value ?? ctr.repository.diagnoseImageFile3.value!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 50),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => _buildRow(ctr.repository.isAnalyzingImage.value, 'analyzingImage'.tr)),
                  const SizedBox(height: 16),
                  Obx(() => _buildRow(ctr.repository.isDetectingLeaves.value, 'detectingLeaves'.tr)),
                  const SizedBox(height: 16),
                  Obx(
                    () => _buildRow(
                      ctr.repository.isIdentifyingPlant.value,
                      ctr.repository.shootType.value == ShootType.identify ? 'identifyingPlant'.tr : 'diagnosingPlant'.tr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(bool isDone, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isDone)
          Image.asset('images/icon/successful.png', width: 20)
        else
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: UIColor.primary,
              strokeWidth: 3,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            color: UIColor.transparent60,
            fontSize: 14,
            fontWeight: FontWeightExt.medium,
            decoration: TextDecoration.none,
          ),
        )
      ],
    );
  }
}
