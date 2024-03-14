import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isInitialized = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      await _controller.initialize();
      _isInitialized = true;
    } catch (e) {
      print("Erro ao inicializar a câmera: $e");
    }
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _controller.dispose();
      _isInitialized = false;
    }
  }

  Future<String?> takePhoto() async {
    try {
      if (!_isInitialized) {
        await initializeCamera();
      }

      XFile? picture = await _controller.takePicture();

      final bytes = await picture.readAsBytes();
      final String base64Image = base64Encode(
        Uint8List.fromList(bytes),
      );
      return base64Image;
    } catch (e) {
      print("Erro ao capturar a imagem: $e");
      return null;
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 768,
        maxHeight: 768,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final String base64Image = base64Encode(
          Uint8List.fromList(bytes),
        );
        return base64Image;
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao selecionar a imagem da galeria: $e");
      return null;
    }
  }

  CameraController getController() {
    return _controller;
  }
}
