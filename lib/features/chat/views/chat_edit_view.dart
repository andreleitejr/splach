import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/chat/controllers/chat_edit_controller.dart';
import 'package:splach/features/chat/models/chat_category.dart';
import 'package:splach/widgets/avatar_image_input.dart';
import 'package:splach/widgets/custom_bottom_sheet.dart';
import 'package:splach/widgets/input.dart';
import 'package:splach/widgets/input_button.dart';

class ChatEditView extends StatelessWidget {
  final controller = Get.put(GroupChatEditController());

  ChatEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Chat em Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Obx(
              () => Center(
                child: AvatarImageInput(
                  image: controller.image.value,
                  onPressed: () async {
                    focus.unfocus();
                    await _getImage(context);
                    // focus.requestFocus(nameFocus);
                  },
                ),
              ),
            ),
            Input(
              controller: controller.titleController,
              hintText: 'Título',
            ),
            Input(
              controller: controller.descriptionController,
              hintText: 'Descrição',
            ),
            InputButton(
              onTap: () => _showCategoryBottomSheet(context),
              controller: controller.categoryController,
              hintText: 'Category',
            ),
            Input(
              controller: controller.addressController.postalCodeController,
              hintText: 'CEP',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CepInputFormatter(),
              ],
            ),
            Input(
              controller: controller.addressController.streetController,
              hintText: 'Rua',
              keyboardType: TextInputType.streetAddress,
            ),
            Input(
              controller: controller.addressController.numberController,
              hintText: 'Numero',
            ),
            Input(
              controller: controller.addressController.cityController,
              hintText: 'Cidade',
            ),
            Input(
              controller: controller.addressController.stateController,
              hintText: 'Estado',
            ),
            Input(
              controller: controller.addressController.countyController,
              hintText: 'Pais',
            ),
            Input(
              controller: controller.addressController.complementController,
              hintText: 'Complemento',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.save();
              },
              child: const Text('Criar Chat em Grupo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(BuildContext context) async {
    final image = await Get.to(
      () => CameraGalleryView(
        image: controller.image.value,
      ),
    );
    if (image != null) {
      controller.image.value = image;
    }
  }

  void _showCategoryBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet<ChatCategory>(
        items: categories,
        title: 'Qual a categoria?',
        onItemSelected: (selectedItem) async {
          controller.categoryController.text = selectedItem.title;
          focus.unfocus();
        },
      ),
      enableDrag: true,
    );
  }
}
