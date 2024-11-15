import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/api/request.dart';
import 'package:plant/common/aws_utils.dart';
import 'package:plant/common/file_utils.dart';
import 'package:plant/common/firebase_util.dart';
import 'package:plant/controllers/user_controller.dart';
import 'package:plant/models/plant_diagnosis_model.dart';
import 'package:plant/models/plant_info_model.dart';
import 'package:plant/router/app_pages.dart';
import 'package:plant/widgets/loading_dialog.dart';
import 'package:image/image.dart' as img;
import 'package:plant/widgets/show_dialog.dart';

import 'scan_page.dart';
import 'widgets/help_example.dart';
import 'widgets/plant_crop_image.dart';

part 'plant_repository.dart';

class PlantController extends GetxController {
  final ShootType shootType;
  final bool hasCamera;
  PlantController(this.shootType, {this.hasCamera = true});
  late final PlantRepository repository;

  @override
  void onInit() {
    super.onInit();
    repository = PlantRepository(shootType);
    if (hasCamera) {
      initCamera();
    }
  }

  @override
  onClose() {
    repository.cameraController?.dispose();
    super.onClose();
  }

  Future<bool> requestIdentifyInfo(Completer<void> completer) async {
    repository.plantInfo = null;
    repository.diagnoseInfo = null;
    await uploadFile(completer);
    if (completer.isCompleted) return false;
    if (repository.identifyImage400Url == null || repository.identifyThumbnailUrl == null) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    try {
      final res = await Request.plantScan(repository.identifyImage400Url!, repository.identifyThumbnailUrl!);
      if (completer.isCompleted) return false;
      if (res.statusCode == 200) {
        final responseData = res.data;
        if (responseData['code'] == 200 || responseData['code'] == 0) {
          repository.isIdentifyingPlant.value = true;
          repository.plantInfo = PlantInfoModel.fromJson(responseData['data']);
          // 成功
          return true;
        }
      }
    } catch (e) {
      Get.log('识别错误：$e', isError: true);
      return false;
    }
    return false;
  }

  Future<bool> requestDiagnoseInfo(Completer<void> completer) async {
    repository.plantInfo = null;
    repository.diagnoseInfo = null;
    await uploadFile(completer);
    if (completer.isCompleted) return false;

    if (repository.diagnoseImageUrls.isEmpty) {
      Fluttertoast.showToast(msg: '图片上传失败', gravity: ToastGravity.CENTER);
      return false;
    }
    try {
      final res = await Request.plantDiagnosis(repository.diagnoseImageUrls);
      if (completer.isCompleted) return false;
      if (res.statusCode == 200) {
        final responseData = res.data;
        if (responseData['code'] == 200 || responseData['code'] == 0) {
          repository.diagnoseImageFile1.value = null;
          repository.diagnoseImageFile2.value = null;
          repository.diagnoseImageFile3.value = null;

          repository.isIdentifyingPlant.value = true;
          repository.diagnoseInfo = PlantDiagnosisModel.fromJson(responseData['data']);
          // 成功
          return true;
        }
      }
    } catch (e) {
      Get.log('识别错误：$e', isError: true);
      return false;
    }

    return false;
  }

  Future<void> uploadFile(Completer<void> completer) async {
    repository.isAnalyzingImage.value = false;
    repository.isDetectingLeaves.value = false;
    repository.isIdentifyingPlant.value = false;

    if (repository.shootType.value == ShootType.identify) {
      repository.identifyImage400Url = null;
      repository.identifyThumbnailUrl = null;
      repository.identifyImage400Url = await AwsUtils.uploadByFile(repository.identifyImage400File!);
      if (completer.isCompleted) return;
      repository.identifyThumbnailUrl = await AwsUtils.uploadByFile(repository.identifyThumbnailFile!);
      if (completer.isCompleted) return;
    } else {
      repository.diagnoseImageUrls.clear();

      if (repository.diagnoseImageFile1.value != null) {
        final file1 = await _resizeImage(repository.diagnoseImageFile1.value!);
        if (file1 == null) {
          return;
        }
        repository.diagnoseImageUrls.add(await AwsUtils.uploadByFile(file1));
        if (completer.isCompleted) return;
      }

      if (repository.diagnoseImageFile2.value != null) {
        final file2 = await _resizeImage(repository.diagnoseImageFile2.value!);
        if (file2 == null) {
          return;
        }
        repository.diagnoseImageUrls.add(await AwsUtils.uploadByFile(file2));
        if (completer.isCompleted) return;
      }

      if (repository.diagnoseImageFile3.value != null) {
        final file3 = await _resizeImage(repository.diagnoseImageFile3.value!);
        if (file3 == null) {
          return;
        }
        repository.diagnoseImageUrls.add(await AwsUtils.uploadByFile(file3));
        if (completer.isCompleted) return;
      }
    }

    repository.isAnalyzingImage.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (completer.isCompleted) return;
      repository.isDetectingLeaves.value = true;
    });
  }

  Future<void> scanByScientificName(int id) async {
    try {
      final res = await Request.getPlantDetailByRecord(id);
      repository.plantInfo = PlantInfoModel.fromJson(res);
    } catch (e) {
      Get.log(e.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> savePlant(int id) async {
    await Request.scanSave(id);
  }

  void didShowHelp() {
    Get.dialog(const HelpExample(), useSafeArea: false);
  }

  void toggleFlashMode() async {
    if (repository.flashMode.value == FlashMode.off) {
      await repository.cameraController?.setFlashMode(FlashMode.torch);
    } else {
      await repository.cameraController?.setFlashMode(FlashMode.off);
    }
    repository.flashMode.value = (repository.flashMode.value == FlashMode.off ? FlashMode.torch : FlashMode.off);
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      repository.cameraController = CameraController(
        firstCamera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
    } catch (e) {
      Get.log('cameras init error:$e', isError: true);
      Get.dialog(
        barrierDismissible: false,
        NormalDialog(
          title: 'Device not detected',
          confirmText: 'ok',
          onConfirm: () {
            Get.until((route) => Get.currentRoute == '/');
          },
        ),
      );
    }
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
    repository.cameraController?.initialize().then((_) {
      repository.isCameraReady.value = true;
      repository.cameraController?.lockCaptureOrientation();
    }).catchError((Object e) {
      Get.log(e.toString(), isError: true);
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // 当用户拒绝相机访问权限时抛出
            NormalDialog.showPermission();
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            // 目前仅限 iOS。当用户先前拒绝权限时抛出。iOS 不允许第二次提示警报对话框。用户必须转到“设置”>“隐私”>“相机”才能启用相机访问权限
            NormalDialog.showPermission();
            break;
          case 'CameraAccessRestricted':
            // 目前仅限 iOS。当相机访问受到限制且用户无法授予权限（家长控制）时抛出。
            NormalDialog.showPermission();
            break;
          case 'AudioAccessDenied':
            // 当用户拒绝音频访问权限时抛出
            NormalDialog.showPermission();
            break;
          case 'AudioAccessDeniedWithoutPrompt':
            // 目前仅限 iOS。当用户先前拒绝权限时抛出。iOS 不允许第二次提示警报对话框。用户必须转到“设置”>“隐私”>“麦克风”才能启用音频访问。
            NormalDialog.showPermission();
            break;
          case 'AudioAccessRestricted':
            // 目前仅限 iOS。当音频访问受到限制且用户无法授予权限（家长控制）时抛出。
            NormalDialog.showPermission();
            break;
          default:
            Fluttertoast.showToast(msg: e.toString());
            break;
        }
      }
    });
  }

  bool checkLogin() {
    if ((Get.find<UserController>().isLogin.value)) {
      return true;
    }
    FireBaseUtil.loginPageEvent(Get.currentRoute);
    Get.toNamed(AppRoutes.login);
    return false;
  }

  Future<void> didShootPhoto() async {
    if (checkLogin()) {
      if (repository.shootType.value == ShootType.identify) {
        await _identifyShootPhoto();
      } else {
        await _diagnoseShootPhoto();
      }
    }
  }

  Future<void> didPickerPhoto() async {
    if (checkLogin()) {
      if (repository.shootType.value == ShootType.identify) {
        _identifyPickerPhoto();
      } else {
        _diagnosePickerPhoto();
      }
    }
  }

  Future<void> _identifyShootPhoto() async {
    Get.dialog(const LoadingDialog());
    try {
      // 设置对焦，提高拍照效率
      // await _controller?.setFocusMode(FocusMode.locked);
      // await _controller?.setExposureMode(ExposureMode.locked);
      if (repository.cameraController?.value.isInitialized ?? false) {
        final XFile imageFile = await repository.cameraController!.takePicture();
        img.Image image = (await FileUtils.xFileToImage(imageFile))!;

///////////// 计算需要裁剪的区域
        final mediaSize = MediaQuery.of(Get.context!).size;
        final showSize = mediaSize.width - 116;
        double scaleFactor = image.width / mediaSize.width;
        double cropWidth = scaleFactor * showSize;
        double x = (image.width - cropWidth) / 2;
        double y = (image.height - cropWidth) / 2;
////////////
        final cropImage = img.copyCrop(image, x: x.toInt(), y: y.toInt(), width: cropWidth.toInt(), height: cropWidth.toInt());
        final imageThumbnailFile = await FileUtils.imageToFile(cropImage);
        final image400 = img.copyResize(cropImage, width: 400, height: 400);
        final image400File = await FileUtils.imageToFile(image400);
        if (imageThumbnailFile == null || image400File == null) {
          return;
        }
        repository.identifyImage400File = image400File;
        repository.identifyThumbnailFile = imageThumbnailFile;
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.to(() => const ScanPage());
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.log(e.toString(), isError: true);
    }
  }

  Future<void> _identifyPickerPhoto() async {
    try {
      final XFile? pickedFile = await repository.imagePicker.pickImage(
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
          NormalDialog.showPermission();
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

  Future<List?> identifyCropImage(Uint8List data) async {
    List<int> jpegBytes = img.encodeJpg(img.decodeImage(data)!, quality: 60);
    final croppedData = Uint8List.fromList(jpegBytes);
    final imageThumbnailFile = await FileUtils.listToFile(croppedData);
    if (imageThumbnailFile == null) {
      return null;
    }
    final cropImage = img.decodeImage(croppedData);
    if (cropImage == null) {
      return null;
    }
    final image400 = img.copyResize(cropImage, width: 400, height: 400);
    final image400File = await FileUtils.imageToFile(image400);
    if (image400File == null) {
      return null;
    }
    return [imageThumbnailFile, image400File];
  }

  void diagnoseDeletePhoto(int index) {
    switch (index) {
      case 0:
        repository.diagnoseImageFile1.value = null;
        break;
      case 1:
        repository.diagnoseImageFile2.value = null;
        break;
      case 2:
        repository.diagnoseImageFile3.value = null;
        break;
      default:
        break;
    }
  }

  Future<void> _diagnoseShootPhoto() async {
    if (repository.cameraController?.value.isInitialized ?? false) {
      final XFile imageFile = await repository.cameraController!.takePicture();
      if (repository.diagnoseImageFile1.value == null) {
        repository.diagnoseImageFile1.value = File(imageFile.path);
        return;
      }
      if (repository.diagnoseImageFile2.value == null) {
        repository.diagnoseImageFile2.value = File(imageFile.path);
        return;
      }
      repository.diagnoseImageFile3.value ??= File(imageFile.path);
      diagnoseScanPhoto();
    }
  }

  _diagnosePickerPhoto() async {
    try {
      int limit = 0;
      if (repository.diagnoseImageFile1.value == null) {
        limit += 1;
      }
      if (repository.diagnoseImageFile2.value == null) {
        limit += 1;
      }
      if (repository.diagnoseImageFile3.value == null) {
        limit += 1;
      }
      if (limit == 0) {
        return;
      }
      List<XFile> pickedFiles = [];
      if (limit == 1) {
        final pickedFile = await repository.imagePicker.pickImage(imageQuality: 60, source: ImageSource.gallery);
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      } else {
        pickedFiles = await repository.imagePicker.pickMultiImage(imageQuality: 60, limit: limit);
      }
      for (final file in pickedFiles) {
        if (repository.diagnoseImageFile1.value == null) {
          repository.diagnoseImageFile1.value = File(file.path);
          continue;
        }
        if (repository.diagnoseImageFile2.value == null) {
          repository.diagnoseImageFile2.value = File(file.path);
          continue;
        }
        if (repository.diagnoseImageFile3.value == null) {
          repository.diagnoseImageFile3.value = File(file.path);
          continue;
        }
      }
      if (repository.diagnoseImageFile3.value != null) {
        diagnoseScanPhoto();
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'photo_access_denied':
          NormalDialog.showPermission();
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

  void diagnoseScanPhoto() {
    if (repository.diagnoseImageFile1.value == null && repository.diagnoseImageFile2.value == null && repository.diagnoseImageFile3.value == null) {
      return;
    }
    Get.to(
      () => const ScanPage(),
    );
  }

  Future<File?> _resizeImage(File file) async {
    final originalImage = img.decodeImage(file.readAsBytesSync());
    if (originalImage == null) {
      return null;
    }
    // 计算等比缩放后的尺寸
    int maxSize = 1920;
    int newWidth = originalImage.width;
    int newHeight = originalImage.height;

    if (newWidth > maxSize || newHeight > maxSize) {
      if (newWidth > newHeight) {
        newHeight = (originalImage.height * maxSize / originalImage.width).round();
        newWidth = maxSize;
      } else {
        newWidth = (originalImage.width * maxSize / originalImage.height).round();
        newHeight = maxSize;
      }
    }

    // 等比缩放图片
    return await FileUtils.imageToFile(img.copyResize(originalImage, width: newWidth, height: newHeight));
  }
}
