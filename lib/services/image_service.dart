import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> takePhoto(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final String base64Image = base64Encode(Uint8List.fromList(bytes));
        return base64Image;
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao capturar a imagem: $e");
      return null;
    }
  }
}
