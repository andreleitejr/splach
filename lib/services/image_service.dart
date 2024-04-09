import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isInitialized = false;
  final ImagePicker _imagePicker = ImagePicker();
  AssetPathEntity? _path;
  final int _sizePerPage = 16;

  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(
        maxWidth: 768,
        maxHeight: 768,
      ),
    ),
  );

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

  Future<File?> takePhoto() async {
    try {
      if (!_isInitialized) {
        await initializeCamera();
      }

      final picture = await _controller.takePicture();

      return File(picture.path);
    } catch (e) {
      print("Erro ao capturar a imagem: $e");
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 768,
        maxHeight: 768,
        imageQuality: 65,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      print("Erro ao selecionar a imagem da galeria: $e");
      return null;
    }
  }

  Future<List<File>?> requestAssets() async {
    final status = await Permission.photos.request();

    if (status.isDenied) {
      print('Permission is not accessible. $status');
      return null;
    }

    final paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      filterOption: _filterOptionGroup,
    );

    if (paths.isEmpty) {
      return null;
    }

    _path = paths.first;

    final entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );

    final files = <File>[];
    for (final entity in entities) {
      final file = await entity.file;
      files.add(file!);
    }

    return files;
  }

  // Future<List<String>> filesToBase64(List<File> files) async {
  //   List<String> base64Images = [];
  //   for (var file in files) {
  //     final bytes = await file.readAsBytes();
  //     final String base64Image = base64Encode(Uint8List.fromList(bytes));
  //     base64Images.add(base64Image);
  //   }
  //   return base64Images;
  // }
  CameraController getController() {
    return _controller;
  }
}
