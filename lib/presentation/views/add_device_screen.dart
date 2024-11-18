import 'package:envirosense/presentation/controllers/AddDeviceController.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../core/constants/colors.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final AddDeviceController _controller = AddDeviceController();
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _isPermissionGranted = await _controller.requestCameraPermission();
    if (_isPermissionGranted) {
      await _controller.initializeCamera();
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      setState(() {}); // Update UI to reflect permission status
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded),
          iconSize: 35,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: const Text(
          'Add Device',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Instruction Text
            const Text(
              'Scan the QR Code on the device.\nYour device will connect automatically.',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28.0),
            Expanded(
              child: Center(
                child: DottedBorder(
                  color: AppColors.secondaryColor,
                  strokeWidth: 2,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: const [6, 3],
                  child: Container(
                    width: double.infinity,
                    height:
                        double.infinity, // Fill the available vertical space
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFF9E6), // Pastel yellow background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isPermissionGranted
                        ? _isCameraInitialized
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CameraPreview(_controller.cameraController!),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                color: AppColors.secondaryColor,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Allow camera access to scan the QR code.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _controller.requestCameraPermission,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                ),
                                child: const Text(
                                  'Allow Camera',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
