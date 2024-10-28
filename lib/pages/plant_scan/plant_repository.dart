part of 'plant_controller.dart';

enum ShootType { identify, diagnose }

class PlantRepository {
  /// 识别类型 identify diagnose
  Rx<ShootType> shootType = ShootType.identify.obs;

  CameraController? cameraController;
  final ImagePicker imagePicker = ImagePicker();

  Rx<FlashMode> flashMode = FlashMode.off.obs;

  RxBool isCameraReady = false.obs;

  /// 压缩到 400* 400
  String? identifyImage400Url;

  /// 需要压缩质量
  String? identifyThumbnailUrl;

  File? identifyThumbnailFile;
  File? identifyImage400File;

  // 识别的图片
  Rx<File?> diagnoseImageFile1 = Rx(null);
  Rx<File?> diagnoseImageFile2 = Rx(null);
  Rx<File?> diagnoseImageFile3 = Rx(null);

  List<String> diagnoseImageUrls = [];

  RxBool isAnalyzingImage = false.obs;
  RxBool isDetectingLeaves = false.obs;
  RxBool isIdentifyingPlant = false.obs;

  PlantInfoModel? plantInfo;
  PlantDiagnosisModel? diagnoseInfo;

  PlantRepository(ShootType type) {
    shootType = type.obs;
  }
}
