import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:plant/common/file_utils.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/btn.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:plant/widgets/show_dialog.dart';
import 'package:plant/pages/plant_scan/plant_controller.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/pages/plant_scan/scan_page.dart';
import 'package:plant/pages/plant_scan/widgets/help_example.dart';

import '../login/login_page.dart';
import 'widgets/plant_crop_image.dart';

class ShootPage extends StatefulWidget {
  const ShootPage({super.key, this.shootType = 'identify'});

  final String shootType;

  @override
  State<ShootPage> createState() => _ShootPageState();
}

class _ShootPageState extends State<ShootPage> {
  CameraController? _controller;

  FlashMode _flashMode = FlashMode.off;

  final ImagePicker _picker = ImagePicker();

  final ctr = Get.put(PlantController());

  @override
  void initState() {
    ctr.shootType.value = widget.shootType;
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
//  on PlatformException catch (e) {
//       switch (e.code) {
//         case 'photo_access_denied':
//           showPermissionDialog();
//           break;
//         default:
//           Fluttertoast.showToast(msg: e.toString());
//           break;
//       }
//       rethrow;
//     }
    _controller!.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((Object e) {
      Get.log(e.toString(), isError: true);
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // 当用户拒绝相机访问权限时抛出
            showPermissionDialog();
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            // 目前仅限 iOS。当用户先前拒绝权限时抛出。iOS 不允许第二次提示警报对话框。用户必须转到“设置”>“隐私”>“相机”才能启用相机访问权限
            showPermissionDialog();
            break;
          case 'CameraAccessRestricted':
            // 目前仅限 iOS。当相机访问受到限制且用户无法授予权限（家长控制）时抛出。
            showPermissionDialog();
            break;
          case 'AudioAccessDenied':
            // 当用户拒绝音频访问权限时抛出
            showPermissionDialog();
            break;
          case 'AudioAccessDeniedWithoutPrompt':
            // 目前仅限 iOS。当用户先前拒绝权限时抛出。iOS 不允许第二次提示警报对话框。用户必须转到“设置”>“隐私”>“麦克风”才能启用音频访问。
            showPermissionDialog();
            break;
          case 'AudioAccessRestricted':
            // 目前仅限 iOS。当音频访问受到限制且用户无法授予权限（家长控制）时抛出。
            showPermissionDialog();
            break;
          default:
            Fluttertoast.showToast(msg: e.toString());
            break;
        }
      }
    });
  }

  void showPermissionDialog() {
    Get.dialog(
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

  Future<void> _didShootPhoto() async {
    if (!(Get.find<UserController>().isLogin.value)) {
      FireBaseUtil.loginPageEvent(Get.currentRoute);
      Get.to(() => const LoginPage(), fullscreenDialog: true);
      return;
    }
    Get.dialog(const LoadingDialog());
    try {
      // 设置对焦，提高拍照效率
      // await _controller?.setFocusMode(FocusMode.locked);
      // await _controller?.setExposureMode(ExposureMode.locked);
      if (_controller?.value.isInitialized ?? false) {
        final XFile imageFile = await _controller!.takePicture();
        img.Image image = (await FileUtils.xFileToImage(imageFile))!;

///////////// 计算需要裁剪的区域
        final showSize = Get.width - 116;
        double scaleFactor = image.width / Get.width;
        double cropWidth = scaleFactor * showSize;
        double x = (image.width - cropWidth) / 2;
        double y = (image.height - cropWidth) / 2;
////////////
        final cropImage = img.copyCrop(image, x: x.toInt(), y: y.toInt(), width: cropWidth.toInt(), height: cropWidth.toInt());
        final cropFile = await FileUtils.imageToFile(cropImage);
        final image400 = img.copyResize(cropImage, width: 400, height: 400);
        final image400File = await FileUtils.imageToFile(image400);
        if (cropFile == null || image400File == null) {
          return;
        }
        Get.back();

        Get.to(
          () => ScanPage(
            cropFile: cropFile,
            image400File: image400File,
          ),
        );
      }
    } catch (e) {
      Get.back();
      Get.log(e.toString(), isError: true);
    }
  }

  Future<void> _didPickerPhoto() async {
    if (!(Get.find<UserController>().isLogin.value)) {
      FireBaseUtil.loginPageEvent(Get.currentRoute);
      Get.to(() => const LoginPage(), fullscreenDialog: true);
      return;
    }
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );
      if (pickedFile != null) {
        Get.dialog(
          PlantCropImage(
            originalFile: File(pickedFile.path),
          ),
          useSafeArea: false,
        );
        // Get.off(() => PlantCropImage(imageData: photoImage));
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'photo_access_denied':
          showPermissionDialog();
          break;
        default:
          Fluttertoast.showToast(msg: e.message ?? 'error', gravity: ToastGravity.CENTER, timeInSecForIosWeb: 5);
          break;
      }
      rethrow;
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  void _didShowHelp() {
    Get.dialog(const HelpExample(), useSafeArea: false);
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width - 116;

    return Container(
      color: UIColor.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: (_controller?.value.isInitialized ?? false) ? CameraPreview(_controller!) : const Center(child: CircularProgressIndicator()),
          ),
          Center(
            child: Image.asset(
              'images/icon/canera_border.png',
              width: width,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: NavBar(
              leftWidget: IconButton(
                onPressed: () async {
                  if (_flashMode == FlashMode.off) {
                    await _controller?.setFlashMode(FlashMode.torch);
                  } else {
                    await _controller?.setFlashMode(FlashMode.off);
                  }
                  setState(() {
                    _flashMode = (_flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off);
                  });
                },
                icon: Image.asset(
                  _flashMode == FlashMode.off ? 'images/icon/flash_close.png' : 'images/icon/flash_open.png',
                  width: 32,
                ),
              ),
              rightWidget: IconButton(
                onPressed: () => Get.back(),
                icon: Image.asset('images/icon/close_back.png', width: 32),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 250,
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(256),
                      ),
                    ),
                    child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: NormalButton(
                              onTap: () {
                                FireBaseUtil.logEvent(EventName.shootIdentify);
                                ctr.shootType.value = 'identify';
                              },
                              text: 'identify'.tr,
                              textColor: ctr.shootType.value == 'identify' ? UIColor.primary : UIColor.white,
                              bgColor: ctr.shootType.value == 'identify' ? UIColor.white : UIColor.transparent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: NormalButton(
                              onTap: () {
                                FireBaseUtil.logEvent(EventName.shootDianose);
                                ctr.shootType.value = 'diagnose';
                              },
                              text: 'diagnose'.tr,
                              textColor: ctr.shootType.value == 'diagnose' ? UIColor.primary : UIColor.white,
                              bgColor: ctr.shootType.value == 'diagnose' ? UIColor.white : UIColor.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FireBaseUtil.logEvent(EventName.shootAlbum);
                            _didPickerPhoto();
                          },
                          child: Image.asset(
                            'images/icon/image_picker.png',
                            width: 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _didShootPhoto();
                          },
                          child: Obx(
                            () => Image.asset(
                              ctr.shootType.value == 'identify' ? 'images/icon/camera_search.png' : 'images/icon/camera_diagnose.png',
                              width: 70,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FireBaseUtil.logEvent(EventName.shootHelp);
                            _didShowHelp();
                          },
                          child: Image.asset(
                            'images/icon/help.png',
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
