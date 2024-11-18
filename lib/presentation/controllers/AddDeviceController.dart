import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDeviceController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras!.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController!.initialize();
  }

  void dispose() {
    cameraController?.dispose();
  }
}
