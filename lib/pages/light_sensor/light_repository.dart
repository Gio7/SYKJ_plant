part of 'light_sensor_controller.dart';

class LightRepository {
  late RxInt lux;
  RxBool isCameraReady = false.obs;
  CameraController? cameraController;

  LightRepository() {
    lux = 0.obs;
  }
}