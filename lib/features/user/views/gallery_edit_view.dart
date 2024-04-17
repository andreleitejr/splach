import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/user/controllers/user_profile_controller.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/input.dart';

class GalleryEditView extends StatelessWidget {
  final UserProfileController controller;

  GalleryEditView({
    super.key,
    required this.controller,
  });

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _imagePreview(context),
            Input(
              hintText: 'Description',
              controller: controller.description,
            ),
            FlatButton(
              actionText: 'Salvar',
              onPressed: () => _save(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final result = await controller.save();

    if (result == SaveResult.success) {
      Get.back();
    }
  }

  Widget _imagePreview(BuildContext context) {
    return Obx(
      () {
        if (controller.image.value == null) {
          return Container();
        }
        return Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  controller.image.value!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
