import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';

class NormalDialog extends StatelessWidget {
  /// 展示权限弹窗
  static Future<void> showPermission() {
    return Get.dialog(
      NormalDialog(
        title: 'photoPermissionTitle'.tr,
        subText: 'photoPermissionTips'.tr,
        icon: Image.asset('images/icon/picture.png', height: 70),
        confirmText: 'goToSettings'.tr,
        onConfirm: () {
          Get.back();
          AppSettings.openAppSettings();
        },
      ),
    );
  }

  const NormalDialog({
    super.key,
    required this.title,
    this.subText,
    required this.confirmText,
    this.cancelText,
    this.icon,
    this.onConfirm,
    this.onCancel,
    this.confirmPositionLeft = true,
  });

  final String title;
  final String? subText;
  final String confirmText;
  final Function()? onConfirm;
  final String? cancelText;
  final Function()? onCancel;
  final Widget? icon;
  final bool confirmPositionLeft;

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          Container(
            margin: const EdgeInsets.all(16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UIColor.c15221D,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          if (subText != null)
            Text(
              subText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UIColor.c8E8B8B,
                fontSize: 14,
                fontWeight: FontWeightExt.medium,
                decoration: TextDecoration.none,
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                if (cancelText != null) ...[
                  confirmPositionLeft ? _buildConfirmBtn() : _buildCancelBtn(),
                  const SizedBox(width: 16),
                  confirmPositionLeft ? _buildCancelBtn() : _buildConfirmBtn(),
                ] else ...[
                  _buildConfirmBtn(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildCancelBtn() {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: NormalButton(
          onTap: onCancel ?? () => Get.back(),
          text: cancelText!,
          textColor: UIColor.white,
          bgColor: UIColor.cD1D1D1,
        ),
      ),
    );
  }

  Expanded _buildConfirmBtn() {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: NormalButton(
          onTap: onConfirm,
          text: confirmText,
          textColor: UIColor.white,
          bgColor: UIColor.c40BD95,
        ),
      ),
    );
  }
}

class DialogContainer extends StatelessWidget {
  const DialogContainer({super.key, required this.child, this.bgColor = UIColor.white});
  final Widget child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width - 40,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// 弹出输入框
///
/// Example:
/// ```
/// Get.dialog(
///   TextFieldDialog(
///     title: 'setYourPlantName'.tr,
///    confirmText: 'save'.tr,
///     cancelText: 'cancel'.tr,
///     onConfirm: (String v) {
///       print(v);
///     },
///   ),
/// );
/// ```
class TextFieldDialog extends StatelessWidget {
  const TextFieldDialog({
    super.key,
    required this.title,
    required this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.value,
    this.hintText,
    this.counterText,
  });

  final String title;
  final String confirmText;
  final Function(String)? onConfirm;
  final String? cancelText;
  final Function()? onCancel;
  final String? value;
  final String? hintText;
  final String? counterText;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    if (value != null) {
      controller.text = value!;
    }
    return DialogContainer(
      child: Material(
        color: UIColor.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: UIColor.c15221D,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 1,
              maxLength: 40,
              controller: controller,
              // focusNode: focusNode,
              style: TextStyle(fontSize: 14, color: UIColor.c15221D, fontWeight: FontWeightExt.medium),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(26),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(26),
                ),
                hintText: hintText ?? 'writeHere'.tr,
                hintStyle: TextStyle(fontSize: 14, color: UIColor.cBDBDBD, fontWeight: FontWeightExt.medium),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                counterText: counterText,
                fillColor: UIColor.cEEEEEE,
                filled: true,
              ),
              // cursorColor: UIColor.cAEE9CD,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: counterText == null ? 8 : 24),
              child: Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: NormalButton(
                          onTap: () => onConfirm?.call(controller.text),
                          text: confirmText,
                          textColor: UIColor.white,
                          bgColor: UIColor.c40BD95,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: NormalButton(
                          onTap: onCancel ?? () => Get.back(),
                          text: cancelText!,
                          textColor: UIColor.white,
                          bgColor: UIColor.cD1D1D1,
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: NormalButton(
                          onTap: () => onConfirm?.call(controller.text),
                          text: confirmText,
                          textColor: UIColor.white,
                          bgColor: UIColor.c40BD95,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部弹出
///
/// Example:
/// ```
/// Get.bottomSheet(
///    BottomPopOptions(children:[])
///)
/// ```
class BottomPopOptions extends StatelessWidget {
  const BottomPopOptions({super.key, this.children, this.child, this.hasClose = true, this.title, this.hasBuoy = false});
  final List<Widget>? children;
  final Widget? child;
  final bool hasClose;
  final String? title;
  final bool hasBuoy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
      decoration: const ShapeDecoration(
        color: UIColor.cF3F4F3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 24),
              if (hasBuoy)
                Container(
                  width: 60,
                  height: 6,
                  decoration: ShapeDecoration(
                    color: UIColor.cD9D9D9,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(256),
                    ),
                  ),
                )
              else if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: UIColor.c15221D,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(width: 24),
              if (hasClose)
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const ImageIcon(
                    AssetImage('images/icon/close.png'),
                    size: 24,
                    color: UIColor.black,
                  ),
                )
              else
                Container(width: 24),
            ],
          ),
          const SizedBox(height: 16),
          if (children != null)
            ...children!
          else if (child != null)
            child!,
        ],
      ),
    );
  }
}
